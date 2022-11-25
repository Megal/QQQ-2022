var express = require('express');
var router = express.Router();
var cookieParser = require('cookie-parser')

var app = express()
app.use(cookieParser())

/* GET home page. */
router.get('/', function(req, res, next) {
    // Cookies that have not been signed
    console.log('Cookies: ', req.cookies)

    if('XDEBUG_SESSION' in req.cookies){
        console.log(req.cookies['XDEBUG_SESSION'] + 'lol');
    }

    // Cookies that have been signed
    console.log('Signed Cookies: ', req.signedCookies)

    res.sendStatus(200);
});

module.exports = router;
