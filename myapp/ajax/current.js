var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    let fromTime = new Date(2022, 11, 29, 8, 0),
        toTime = new Date(2022, 11, 29, 9, 50);

    let json = {
        lessonName: 'Compuhter science',
        professorName: 'Иванов И. О.',
        from: fromTime.toISOString(),
        to: toTime.toISOString(),
        url: 'https://yandex.ru'
    };

    res.json(json);
});

module.exports = router;
