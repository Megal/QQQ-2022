var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    global.connDB.query('SELECT * FROM Questions', function (error, results, fields) {
        if (error) throw error;
        res.json(results);
    });
});

module.exports = router;
