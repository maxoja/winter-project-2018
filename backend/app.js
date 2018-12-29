var generate_id = require('./generate_id.js');
var jsonFactory = require('./json_factory.js');
var config = require('./private.js');

var mysql = require('sync-mysql');
var connection = new mysql(config);

var express = require('express');
var bodyParser = require('body-parser');

var app = express();

function validateToken(id, token) {
    id = parseInt(id);
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
    var newUser = { "id": fields['insertId'].toString(), "token": newToken, "name": name };

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${newToken}'`);

    res.json(jsonFactory(true, { "newUser": newUser }));
});

app.post('/changeName', function (req, res) {
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
    var name = req.body['name'];
    var image = req.body['image'];
    var description = req.body['description'];

    if (!validateToken(id, token)) {
        res.json(jsonFactory(false, "Invalid Token."));
        return;
    }

    var fields = connection.query(`INSERT INTO recipes (uid, name, image, description) VALUES (${id}, '${name}', '${image}', '${description}')`);

    res.json(jsonFactory(true, {"rid":fields['insertId']}));
});

app.post('/getRecipes', function (req, res) {
    var id = req.body['id'];

    var recipes = connection.query(`SELECT * FROM recipes WHERE uid = '${id}'`);
    res.json(jsonFactory(true, { "recipes": recipes }));
});

// app.all('/GetRecipeReactions', function (req, res) {
//     var id = req.body['id'];

//     var recipe = connection.query(`SELECT * FROM recipes WHERE id = '${id}'`);
//     res.json(jsonFactory(true, {"recipe-info":recipe}));
// });

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
            
            res.json(jsonFactory(true, {"reaction":reaction}));
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

                res.json(jsonFactory(true, {"reaction":reaction}));
            } else {
                var updatingColumnName = oldReaction == "LIKE" ? 'likes' : 'dislikes';

                connection.query(`DELETE FROM reactions WHERE uid = ${uid} and rid = ${rid}`);
                connection.query(`UPDATE recipes SET ${updatingColumnName} = ${updatingColumnName} - 1 WHERE id = ${rid}`);
                
                res.json(jsonFactory(true, {"reaction":reaction}));
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
        res.json(jsonFactory(false, "Invalid Token."))
    }

    var reaction = connection.query(`SELECT reaction FROM reactions WHERE uid = '${uid}' and rid = '${rid}'`);

    if (reaction.length == 0) {
        res.json(jsonFactory(true, {"reaction":"NONE"}));
    }
    res.json(jsonFactory(true, reaction));
});

// var maxID = null;

// var results = connection.query('SELECT MAX(id) FROM users;');
// console.log(results[0]);
// var num = BigInt(results[0]['MAX(id)']);
// maxID = num;

PORT = 3000
app.listen(PORT, function () {
    console.log(`Server started on port ${PORT}.`);
});

// console.log(validateToken('1', '300'));
// console.log(validateToken('2', '10'));

