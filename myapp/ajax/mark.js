var express = require('express');
var qrgen = require('qrcode');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    let qrUrl;
    qrgen.toDataURL('Hello World !').then(url =>{
        qrUrl = url;
    });


    res.render('index', { title: 'Express', qrUrl: url});
    qrgen.toDataURL('I am a pony!', function (err, url) {
        console.log(url)
    })
});

module.exports = router;
