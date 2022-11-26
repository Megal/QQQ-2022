var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.post('/', jsonParser, function(req, res, next) {
    if(req.body['qrCode'] !== undefined)
    {
        if(global.qrArray.has(req.body['qrCode']))
            res.json('ok');
        else
            res.json('err');
    }
    else
        res.sendStatus(500);
});

module.exports = router;