var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    if(req.body['teacherId'] !== undefined)
    {
        console.log(req.body['teacherId']);

    }
    else
        res.sendStatus(500);
});

module.exports = router;