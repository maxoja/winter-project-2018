var generate_id = require('./generate_id.js');
var jsonFactory = require('./json_factory.js');
var config = require('./private.js');

var mysql = require('sync-mysql');
var connection = new mysql(config);

var express = require('express');
var bodyParser = require('body-parser');
var path = require('path');

var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/RequestID', function (req, res) {
    maxID += BigInt(1);
    var newID = maxID;
    var newToken = generate_id();

    var tokens = Array.from(connection.query("SELECT token FROM users")).map(x => x['token']);

    while (tokens.includes(newToken)) {
        newToken = generate_id();
    }

    var fields = connection.query(`INSERT INTO users (token) VALUES ('${newToken}')`);

    var newUser = {"id":fields['insertId'].toString(), "token":newToken};

    res.json(jsonFactory(true, {"newUser":newUser}));
});

app.post('/ChangeName', function (req, res) {
    var token = req.body['token'];
    var name = req.body['name'];

    connection.query(`UPDATE users SET name = '${name}' WHERE token = '${token}'`);
    res.json(jsonFactory(true, {"name":name}));
});

app.post('/CreateRecipe', function (req, res) {
    var token = req.body['token'];
    var name = req.body['name'];
    var image = req.body['image'];
    var description = req.body['description'];

    var id = Array.from(connection.query(`SELECT id FROM users WHERE token = '${token}'`));
    if (id.length == 0) res.json(jsonFactory(false, "Invalid Token."));

    id = id[0]['id'];

    connection.query(`INSERT INTO recipes (uid, name, image, description) VALUES (${id}, '${name}', '${image}', '${description}')`);

    res.json(jsonFactory(true, null));
});

var maxID = null;

var results = connection.query('SELECT MAX(id) FROM users;');
console.log(results[0]);
var num = BigInt(results[0]['MAX(id)']);
maxID = num;

app.listen(3000, function () {
    console.log("Server started on port 3000.");
});

