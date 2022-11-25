var express = require('express');
var router = express.Router();
var cookieParser = require('cookie-parser')

var app = express()
app.use(express.json());

/* GET home page. */
router.get('/', function(req, res, next) {
    res.sendStatus(200);
});

module.exports = router;
