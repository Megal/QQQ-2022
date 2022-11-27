var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.post('/', jsonParser, function(req, res, next) {
    if(req.body['qrCode'] !== undefined)
    {
        console.log(req.body['qrCode']);
        if(global.qrArray.has(req.body['qrCode'])) {

            global.connDB.query(
                'INSERT StudentPresence\n' +
                `SET studentId=${global.qrArray.get(req.body['qrCode']).studentId},\n` +
                `lessonId=${global.qrArray.get(req.body['qrCode']).lessonId}, presence=1;`,
                function (error, results, fields) {
                if (error) throw error;

                res.json('ok');
            });
        }
        else
            res.json('err');
    }
    else
        res.sendStatus(500);
});

module.exports = router;