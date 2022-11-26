var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.post('/', jsonParser, function(req, res, next) {
    console.log(req.body['qrCode']);
    res.json("ok");
});

module.exports = router;