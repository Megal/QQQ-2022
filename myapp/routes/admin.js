var express = require('express');
var router = express.Router();

var hbs = require('hbs')

hbs.registerHelper('isoToTime', function (isoTime) {
    let date = new Date(isoTime);
    return date.getHours().toString().padStart(2, '0') + ':' + date.getMinutes().toString().padStart(2, '0');
})

router.get('/', function(req, res, next) {
    let result = null;
    global.connDB.query('select Lesson.Name, Lesson.Location, Lesson.TimeStart, Lesson.TimeEnd, T.Name as tName, T.Surname as tSurname from Lesson\n' +
        'join Teacher T on Lesson.TeacherID = T.TeacherID;', function (error, results, fields) {
        if (error) throw error;

        results.forEach(el => {
           let timeNow = new Date(2022, 10, 26, 11);
            if(timeNow >= el['TimeStart'] && timeNow <= el['TimeEnd'])
                el['isCurrent'] = true;
        });

        res.render('admin', {
            title: 'Admin-panel',
            lessons: results,
        });
    });
});

module.exports = router;
