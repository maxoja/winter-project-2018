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

    console.log(id, token, name);

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

    if (!validateToken(id, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var fields = connection.query(`INSERT INTO recipes (uid, title, image, description, difficulty) VALUES (${id}, '${title}', '${image}', '${description}', ${difficulty})`);

    res.json(jsonFactory(true, { "rid": fields['insertId'] }));
});

app.post('/getRecipes', function (req, res) {

    //INCLUDE USERNAME;

    var id = req.body['id'];

    var recipes = connection.query(`SELECT * FROM recipes WHERE uid = '${id}'`);
    res.json(jsonFactory(true, { "recipes": recipes }));
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
        console.log(oldReaction);

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

    var uid = req.body['id'];

    var recipes = connection.query(`SELECT * FROM recipes WHERE uid != ${uid}`);

    var recipeCount = recipes.length > RANDOM_RECIPE_COUNT ? RANDOM_RECIPE_COUNT : recipes.length;

    var pickedRecipes = []

    for (var i = 0; i < recipeCount; ++i) {
        var randomizedIndex = Math.floor(Math.random() * recipes.length);
        console.log(recipes.length, randomizedIndex);
        pickedRecipes.push(recipes[randomizedIndex]);
        recipes.splice(randomizedIndex, 1);
    }

    res.json(jsonFactory(true, { "recipes": pickedRecipes }));
});

app.all('/search', function (req, res) {

    var title = req.body['title'];
    var ingredients = req.body['ingredients'];
    var difficulty = req.body['difficulty'];

    var titleCondition = `title LIKE '%${title}%'`;
    
    var difficultyCondition = difficulty === null ? '' : `and difficulty <= ${difficulty}`;;

    var recipes = connection.query(`SELECT * FROM recipes WHERE ${titleCondition} ${difficultyCondition}`);

    recipes = recipes.filter(function(recipe) {
        for (var i in ingredients) {
            if (!recipe['description'].toLowerCase().includes(ingredients[i].toLowerCase())) {
                return false;
            }
        }
        return true;
    })

    res.json(jsonFactory(true, { "recipes":recipes }));
});

PORT = 3000
app.listen(PORT, function () {
    console.log(`Server started on port ${PORT}.`);
});
