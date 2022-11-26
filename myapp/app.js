var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var mysql      = require('mysql8');
global.connDB = mysql.createConnection({
  host     : 'localhost',
  user     : 'user',
  password : '0000',
  database : 'cyberGardenDB'
});


global.connDB.connect(function(err) {
  if (err) {
    console.error('error connecting: ' + err.stack);
    return;
  }

  console.log('connected as id ' + global.connDB.threadId);
});

var indexRouter = require('./routes/index');
var currentAjax = require('./ajax/current');
var markAjax = require('./ajax/mark');
var getQuestionsAjax = require('./ajax/getQuestions')

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/css', express.static(__dirname + '/node_modules/bootstrap/dist/css'));
app.use('/jquery', express.static(__dirname + '/node_modules/jquery/dist'));

app.use('/', indexRouter);
app.use('/current', currentAjax);
app.use('/mark', markAjax);
app.use('/getQuestions', getQuestionsAjax);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


module.exports = app;
