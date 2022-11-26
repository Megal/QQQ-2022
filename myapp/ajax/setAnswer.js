var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.post('/', jsonParser, function(req, res, next) {
    console.log(req.body);

    // global.connDB.query('SELECT * FROM Questions', function (error, results, fields) {
    //     if (error) throw error;
    //     res.json(results);
    // });

    res.sendStatus(200);
});

module.exports = router;
