const generate_id = require('./generate_token.js');
const jsonFactory = require('./json_factory.js');
const config = require('./private.js');

const RANDOM_RECIPE_COUNT = 10;
const MAX_SEARCHED_RECIPE_COUNT = 16;
const DIFFICULTY_NOT_SPECIFIED = 10;

var mysql = require('sync-mysql');
var connection = new mysql(config);

var pluralize = require('pluralize');

var express = require('express');
var bodyParser = require('body-parser');

var app = express();

function validateToken(id, token) {

    var userCount = connection.query(`SELECT COUNT(*) FROM users WHERE id = ${id} and token = '${token}'`);

    return userCount[0]['COUNT(*)'] == 1;
}

function validateBody(body, properties) {
    var errorMessage = "";
    for (var i in properties) {
        var element = body[properties[i]];
        if (element === undefined) {
            errorMessage += properties[i] + " is undefined.\n"; 
        }
    }
    return errorMessage;
}

// function usernameFromID(uid) {
//     var username = connection.query(`SELECT name FROM users WHERE id = ${uid}`);

//     if (username.length == 0) {
//         return "";
//     }
//     return username[0]['name'];
// }

function usernameAndImageFromID(uid) {
    var user = connection.query(`SELECT name, imageUrl FROM users WHERE id = ${uid}`);

    if (user.length == 0) {
        return null;
    }
    return user[0];
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

//DEPRECATED
// function adjustRecipeFormat(recipe, user = null) {

//     var uid = recipe['uid'];

//     if (user === null) {
//         user = usernameAndImageFromID(uid);
//         user['id'] = uid;
//     }

//     recipe['rid'] = recipe['id'];
//     recipe['owner'] = user;
//     recipe['tags'] = tagsOfRecipe(recipe['rid']);

//     delete recipe['id'];
//     delete recipe['uid'];

//     return recipe;
// }

function adjustRecipeFormat2(recipe, user = null, tags = null) {

    var owner = user === null ? 
                            {"id":recipe['uid'], "name":recipe['username'], "imageUrl":recipe['userImageUrl']} :
                            user;

    recipe['rid'] = recipe['id'];
    recipe['owner'] = owner;
    recipe['tags'] = tags != null ? tags : tagsOfRecipe(recipe['rid']);

    delete recipe['id'];
    delete recipe['uid'];
    delete recipe['username'];
    delete recipe['userImageUrl'];

    return recipe;
}

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.all('/requestAccount', function (req, res) {

    console.log("\nRequest Account");

    var newToken = generate_id();
    var tokens = Array.from(connection.query("SELECT token FROM users")).map(x => x['token']);

    while (tokens.includes(newToken)) {
        newToken = generate_id();
    }

    var fields = connection.query(`INSERT INTO users (token) VALUES ('${newToken}')`);

    var newId = fields['insertId'].toString();
    var name = "chef#" + newId;
    var newUser = { "id": newId, "token": newToken, "name": name, "imageUrl":"" };

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${newToken}'`);

    console.log("New User: " + newUser.toString());
    res.json(jsonFactory(true, { "newUser": newUser }));
});

app.all('/changeName', function (req, res) {

    console.log("\nChange Name")

    var errorMessage = validateBody(req.body, ["id", "token", "name"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var id = req.body['id'];
    var token = req.body['token'];
    var name = req.body['name'];

    if (!validateToken(id, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
    }

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${token}'`);

    console.log(`Name Changed to "${name}"`);
    res.json(jsonFactory(true, { "name": name }));
});

app.all('/postRecipe', function (req, res) {

    console.log("\nPost Recipe");

    var errorMessage = validateBody(req.body, ["id", "token", "title", "image", "description", "difficulty", "tags"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var id = req.body['id'];
    var token = req.body['token'];
    var title = req.body['title'];
    var image = req.body['image'];
    var description = req.body['description'];
    var difficulty = req.body['difficulty'];
    var tags = req.body['tags'];

    tags = [...new Set(JSON.parse(tags))].map(x => pluralize.singular(x).toLowerCase());

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
        var tagExist = existingTags.indexOf(tags[i]);
        var tid;
        if (tagExist == -1) {
            tid = addTagToDatabase(tag);
            existingTags.push(tag);
            tids.push(tid);
        } else {
            tid = tids[tagExist];
        }
        connection.query(`INSERT INTO rectag (rid, tid) VALUES (${rid}, ${tid})`);
    }

    res.json(jsonFactory(true, { "rid": rid }));

    console.log("Posted Recipe ID: " + rid);
});

app.all('/getProfile', function (req, res) {

    console.log("\nGetting Profile");

    var errorMessage = validateBody(req.body, ["id"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var id = req.body['id'];

    var user = usernameAndImageFromID(id);
    if (user === null) {
        res.json(jsonFactory(false, "No user with id: ${id}"));
        return;
    }
    user['id'] = id;

    var recipes = connection.query(`SELECT *,
                                        (SELECT name FROM users WHERE id = r.uid) as username, 
                                        (SELECT imageUrl FROM users WHERE id = r.uid) as userImageUrl
                                    FROM recipes r 
                                    WHERE uid = ${id}`);
    recipes = recipes.map(x => adjustRecipeFormat2(x, user));

    res.json(jsonFactory(true, { "user": user, "recipes": recipes }));
    console.log("Profile: " + user.toString());
    console.log("Recipes: " + recipes.toString());
});

app.all('/setReaction', function (req, res) {

    console.log("\nSetting Reaction");

    var errorMessage = validateBody(req.body, ["uid", "token", "reaction", "rid"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var uid = req.body['uid'];
    var token = req.body['token'];
    var reaction = req.body['reaction'];
    var rid = req.body['rid'];

    if (!validateToken(uid, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var oldReaction = connection.query(`SELECT reaction FROM reactions WHERE uid = ${uid} and rid = ${rid}`);

    console.log("From " + oldReaction + " to " + reaction);

    if (oldReaction.length == 0) {
        if (reaction != "NONE") {
            //NONE -> LIKE/DISLIKE
            var updatingColumnName = reaction == "LIKE" ? 'likes' : 'dislikes';
            connection.query(`INSERT INTO reactions (uid, rid, reaction) VALUES (${uid}, ${rid}, '${reaction}')`);
            connection.query(`UPDATE recipes SET ${updatingColumnName} = ${updatingColumnName} + 1 WHERE id = ${rid}`);

            res.json(jsonFactory(true, { "reaction": reaction }));
            return;
        } else {
            //NONE -> NONE
            res.json(jsonFactory(false, "Setting reaction from NONE to NONE"));
            return;
        }
    } else {
        oldReaction = oldReaction[0]['reaction'];

        if (oldReaction != reaction) {
            if (reaction != "NONE") {
                var likeOperator, dislikeOperator;
                if (reaction == "LIKE") {
                    // DISLIKE -> LIKE
                    likeOperator = '+'
                    dislikeOperator = '-'
                } else if (reaction == "DISLIKE") {
                    // LIKE -> DISLIKE
                    likeOperator = '-'
                    dislikeOperator = '+'
                }

                connection.query(`UPDATE reactions SET reaction = '${reaction}' WHERE uid = ${uid} and rid = ${rid}`);
                connection.query(`UPDATE recipes SET likes = likes ${likeOperator} 1, dislikes = dislikes ${dislikeOperator} 1 WHERE id = ${rid}`);

                res.json(jsonFactory(true, { "reaction": reaction }));
            } else {
                // LIKE/DISLIKE -> NONE
                var updatingColumnName = oldReaction == "LIKE" ? 'likes' : 'dislikes';

                connection.query(`DELETE FROM reactions WHERE uid = ${uid} and rid = ${rid}`);
                connection.query(`UPDATE recipes SET ${updatingColumnName} = ${updatingColumnName} - 1 WHERE id = ${rid}`);

                res.json(jsonFactory(true, { "reaction": reaction }));
            }
            return;
        }
        // LIKE -> LIKE / DISLIKE -> DISLIKE
        res.json(jsonFactory(false, `Setting reaction from ${oldReaction} to ${reaction}`));
    }
});

app.all('/currentReaction', function (req, res) {

    console.log("\nCurrent Reaction");

    var errorMessage = validateBody(req.body, ["uid", "token", "rid"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var uid = req.body['uid'];
    var token = req.body['token'];
    var rid = req.body['rid'];

    if (!validateToken(uid, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var reaction = connection.query(`SELECT reaction FROM reactions WHERE uid = '${uid}' and rid = '${rid}'`);
    var result = reaction.length == 0 ? "NONE" : reaction[0]['reaction'];
    
    res.json(jsonFactory(true, { "reaction": result }));
        
    console.log(`Reaction of ${uid} to ${rid} = ${result}`);
});

//DEPRECATED ------------------------------------------------------------------------
// app.all('/randomRecipes', function (req, res) {

//     console.log("\nRandom Recipes");

//     var errorMessage = validateBody(req.body, ["id"]);
//     if (errorMessage != "") {
//         console.log(errorMessage);
//         res.json(jsonFactory(false, errorMessage));
//         return;
//     }

//     var uid = req.body['id'];

//     var recipes = connection.query(`SELECT * FROM recipes WHERE uid != ${uid}`);

//     var recipeCount = recipes.length > RANDOM_RECIPE_COUNT ? RANDOM_RECIPE_COUNT : recipes.length;

//     var pickedRecipes = []
//     for (var i = 0; i < recipeCount; ++i) {
//         var randomizedIndex = Math.floor(Math.random() * recipes.length);
//         pickedRecipes.push(recipes[randomizedIndex]);
//         recipes.splice(randomizedIndex, 1);
//     }

//     pickedRecipes = pickedRecipes.map(x => adjustRecipeFormat(x));

//     res.json(jsonFactory(true, { "recipes": pickedRecipes }));
// });
//DEPRECATED ------------------------------------------------------------------------

app.all('/randomRecipes2', function (req, res) {

    console.log("\nRandom Recipes");

    var errorMessage = validateBody(req.body, ["id"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var uid = req.body['id'];

    var recipes = connection.query(`SELECT *, 
	                                        (SELECT name FROM users WHERE id = r.uid) as username, 
	                                        (SELECT imageUrl FROM users WHERE id = r.uid) as userImageUrl
                                    FROM recipes r
                                    WHERE r.uid != ${uid}
                                    ORDER BY RAND()
                                    LIMIT 10`);

    recipes = recipes.map(x => adjustRecipeFormat2(x));

    res.json(jsonFactory(true, {"recipes": recipes}));
});

app.all('/search', function (req, res) {

    console.log("\nSearch Recipes");

    var errorMessage = validateBody(req.body, ["title", "tags", "difficulty"]);
    if (errorMessage != "") {
        console.log(errorMessage);
        res.json(jsonFactory(false, errorMessage));
        return;
    }

    var title = req.body['title'];
    var tags = req.body['tags'];
    var difficulty = req.body['difficulty'];

    tags = [...new Set(JSON.parse(tags))].map(x => pluralize.singular(x).toLowerCase());

    var titleCondition = `title LIKE '%${title}%'`;
    var difficultyCondition = difficulty === null ? '' : `and difficulty <= ${difficulty}`;;

    var recipes = connection.query(`SELECT *,
                                        (SELECT name FROM users WHERE id = r.uid) as username, 
                                        (SELECT imageUrl FROM users WHERE id = r.uid) as userImageUrl
                                    FROM recipes r
                                    WHERE ${titleCondition} ${difficultyCondition}
                                    ORDER BY r.id DESC`);

    var matchedRecipe = []

    for (var i in recipes) {
        recipeTags = tagsOfRecipe(recipes[i]['id']);
        var matched = true;
        for (var j in tags) {
            if (!recipeTags.includes(tags[j])) {
                matched = false;
                break;
            }
        }
        if (matched) {
            matchedRecipe.push(adjustRecipeFormat2(recipes[i], null, recipeTags));
            if (matchedRecipe.length >= MAX_SEARCHED_RECIPE_COUNT) break;
        }
    }

    res.json(jsonFactory(true, { "recipes": matchedRecipe }));
});

PORT = 3000
app.listen(PORT, function () {
    console.log(`Server started on port ${PORT}.`);
});
