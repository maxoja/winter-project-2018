const generate_id = require('./generate_id.js');
const jsonFactory = require('./json_factory.js');
const config = require('./private.js');

const RANDOM_RECIPE_COUNT = 10;
const DIFFICULTY_NOT_SPECIFIED = 10;

var mysql = require('sync-mysql');
var connection = new mysql(config);

var express = require('express');
var bodyParser = require('body-parser');

var app = express();

function validateToken(id, token) {

    var userCount = connection.query(`SELECT COUNT(*) FROM users WHERE id = ${id} and token = '${token}'`);

    return userCount[0]['COUNT(*)'] == 1;
}

function usernameFromID(uid) {
    var username = connection.query(`SELECT name FROM users WHERE id = ${uid}`);

    if (username.length == 0) {
        return "";
    }
    return username[0]['name'];
}

function tagsOfRecipe(rid) {
    var tags = connection.query(`SELECT tag FROM tags WHERE id IN 
                                    (SELECT tid FROM rectag WHERE rid = ${rid})`);
    return tags.map(x => x['tag']);
}

function addTagToDatabase(tag) {
    var fields = connection.query(`INSERT INTO tags (tag) VALUES ('${tag}')`);
    return fields['insertId'];
}

function adjustRecipeFormat(recipe, username = null) {
    var uid = recipe['uid'];

    username = username === null ? usernameFromID(uid) : username;

    recipe['rid'] = recipe['id'];
    recipe['owner'] = { 'id': uid, 'name': username };
    recipe['tags'] = tagsOfRecipe(recipe['rid']);

    delete recipe['id'];
    delete recipe['uid'];

    return recipe;
}

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/requestAccount', function (req, res) {

    var newToken = generate_id();
    var tokens = Array.from(connection.query("SELECT token FROM users")).map(x => x['token']);

    while (tokens.includes(newToken)) {
        newToken = generate_id();
    }

    var fields = connection.query(`INSERT INTO users (token) VALUES ('${newToken}')`);

    var newId = fields['insertId'].toString();
    var name = "chef#" + newId;
    var newUser = { "id": newId, "token": newToken, "name": name };

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${newToken}'`);

    res.json(jsonFactory(true, { "newUser": newUser }));
});

app.all('/changeName', function (req, res) {

    var id = req.body['id'];
    var token = req.body['token'];
    var name = req.body['name'];

    if (!validateToken(id, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
    }

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${token}'`);
    res.json(jsonFactory(true, { "name": name }));
});

app.post('/postRecipe', function (req, res) {

    var id = req.body['id'];
    var token = req.body['token'];
    var title = req.body['title'];
    var image = req.body['image'];
    var description = req.body['description'];
    var difficulty = req.body['difficulty'];
    var tags = req.body['tags'];

    if (!validateToken(id, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var fields = connection.query(`INSERT INTO recipes (uid, title, image, description, difficulty) VALUES (${id}, '${title}', '${image}', '${description}', ${difficulty})`);
    var rid = fields['insertId'];

    var tagTable = connection.query(`SELECT * FROM tags`);
    var tids = tagTable.map(x => x['id']);
    var existingTags = tagTable.map(x => x['tag']);

    for (var i in tags) {
        //addTagToRecipe(rid, tags[i]);
        var tagExist = existingTags.indexOf(tags[i]);
        var tid;
        if (tagExist == -1) {
            tid = addTagToDatabase(tags[i]);
        } else {
            tid = tids[tagExist];
        }
        connection.query(`INSERT INTO rectag (rid, tid) VALUES (${rid}, ${tid})`);
    }

    res.json(jsonFactory(true, { "rid": rid }));
});

app.post('/getProfile', function (req, res) {

    var id = req.body['id'];

    var username = usernameFromID(id);
    if (username == "") {
        res.json(jsonFactory(false, "No user with id: ${id}"));
        return;
    }

    var recipes = connection.query(`SELECT * FROM recipes WHERE uid = ${id}`);
    recipes = recipes.map(x => adjustRecipeFormat(x, username));

    res.json(jsonFactory(true, { "user": { "id": id, "name": username }, "recipes": recipes }));
});

app.all('/setReaction', function (req, res) {

    var uid = req.body['uid'];
    var token = req.body['token'];
    var reaction = req.body['reaction'];
    var rid = req.body['rid'];

    if (!validateToken(uid, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var oldReaction = connection.query(`SELECT reaction FROM reactions WHERE uid = ${uid} and rid = ${rid}`);

    if (oldReaction.length == 0) {
        if (reaction != "NONE") {
            var updatingColumnName = reaction == "LIKE" ? 'likes' : 'dislikes';
            connection.query(`INSERT INTO reactions (uid, rid, reaction) VALUES (${uid}, ${rid}, '${reaction}')`);
            connection.query(`UPDATE recipes SET ${updatingColumnName} = ${updatingColumnName} + 1 WHERE id = ${rid}`);

            res.json(jsonFactory(true, { "reaction": reaction }));
            return;
        }
        res.json(jsonFactory(false, "Setting reaction from NONE to NONE"));
    } else {
        oldReaction = oldReaction[0]['reaction'];

        if (oldReaction != reaction) {
            if (reaction != "NONE") {
                var likeOperator, dislikeOperator;
                if (reaction == "LIKE") {
                    // Update reactions

                    // -Dislike in recipes
                    // +Like in recipes
                    likeOperator = '+'
                    dislikeOperator = '-'
                } else if (reaction == "DISLIKE") {
                    // Update reactions
                    // +Dislike in recipes
                    // -Like in recipes
                    likeOperator = '-'
                    dislikeOperator = '+'
                }

                connection.query(`UPDATE reactions SET reaction = '${reaction}' WHERE uid = ${uid} and rid = ${rid}`);
                connection.query(`UPDATE recipes SET likes = likes ${likeOperator} 1, dislikes = dislikes ${dislikeOperator} 1 WHERE id = ${rid}`);

                res.json(jsonFactory(true, { "reaction": reaction }));
            } else {
                var updatingColumnName = oldReaction == "LIKE" ? 'likes' : 'dislikes';

                connection.query(`DELETE FROM reactions WHERE uid = ${uid} and rid = ${rid}`);
                connection.query(`UPDATE recipes SET ${updatingColumnName} = ${updatingColumnName} - 1 WHERE id = ${rid}`);

                res.json(jsonFactory(true, { "reaction": reaction }));
            }
            return;
        }
        res.json(jsonFactory(false, `Setting reaction from ${oldReaction} to ${reaction}`));
    }
});

app.all('/currentReaction', function (req, res) {

    var uid = req.body['id'];
    var token = req.body['token'];
    var rid = req.body['rid'];

    if (!validateToken(uid, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var reaction = connection.query(`SELECT reaction FROM reactions WHERE uid = '${uid}' and rid = '${rid}'`);

    if (reaction.length == 0) {
        res.json(jsonFactory(true, { "reaction": "NONE" }));
        return;
    }
    res.json(jsonFactory(true, reaction));
});

app.all('/randomRecipes', function (req, res) {

    console.log("START");

    var uid = req.body['id'];

    var recipes = connection.query(`SELECT * FROM recipes WHERE uid != ${uid}`);

    var recipeCount = recipes.length > RANDOM_RECIPE_COUNT ? RANDOM_RECIPE_COUNT : recipes.length;

    var pickedRecipes = []
    for (var i = 0; i < recipeCount; ++i) {
        var randomizedIndex = Math.floor(Math.random() * recipes.length);
        pickedRecipes.push(recipes[randomizedIndex]);
        recipes.splice(randomizedIndex, 1);
    }

    pickedRecipes = pickedRecipes.map(x => adjustRecipeFormat(x));

    res.json(jsonFactory(true, { "recipes": pickedRecipes }));

    console.log("END");
});

app.all('/search', function (req, res) {

    var title = req.body['title'];
    var ingredients = req.body['ingredients'];
    var difficulty = req.body['difficulty'];

    var titleCondition = `title LIKE '%${title}%'`;

    var difficultyCondition = difficulty === null ? '' : `and difficulty <= ${difficulty}`;;

    var recipes = connection.query(`SELECT * FROM recipes WHERE ${titleCondition} ${difficultyCondition}`);

    recipes = recipes.filter(function (recipe) {
        // for (var i in ingredients) {
        //     if (!recipe['description'].toLowerCase().includes(ingredients[i].toLowerCase())) {
        //         return false;
        //     }
        // }
        return true;
    })

    recipes = recipes.map(x => adjustRecipeFormat(x));

    res.json(jsonFactory(true, { "recipes": recipes }));
});

PORT = 3000
app.listen(PORT, function () {
    console.log(`Server started on port ${PORT}.`);
});
