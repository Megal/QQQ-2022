var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    let questions = [
        {
            question: 'Корень кубический из 49',
            answers: [
              "7",
              "5",
              "14"
            ],
            correctAnswer: 1,
        },
        {
            question: 'Стоимость 98 сегодня',
            answers: [
                "42",
                "54",
                "71"
            ],
            correctAnswer: 2,
        }
    ];
    res.json(questions);
    res.sendStatus(200);
});

module.exports = router;
