var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.get('/', jsonParser, function(req, res, next) {
    if(req.body['id'] === undefined)
        res.sendStatus(500);

    global.connDB.query(
        'select Lesson.Name, Lesson.TimeStart, Lesson.TimeEnd, Lesson.Location, Lesson.IsOnline,\n' +
        '       T.Name as tName, T.Surname as tSurname FROM Lesson\n' +
        `join Student S on StudentID = ${req.body['id']}\n` +
        'join `Group` G on G.GroupID = S.GroupID\n' +
        'join GroupLessons GL on GL.GroupID = G.GroupID\n' +
        'join Lesson L on L.LessonID = GL.LessonID\n' +
        'join Teacher T on Lesson.TeacherID = T.TeacherID\n' +
        `WHERE Lesson.TimeStart <= \'${global.currTime}\' and \'${global.currTime}\' <= Lesson.TimeEnd;`,
        function (error, results, fields) {
            if (error) throw error;
            if(results[0] !== undefined) {
                let qrCode;

                global.qrArray.forEach((who, qr) => {
                    if(who['studentID'] == req.body['id']) {
                        qrCode = qr;
                        return true
                    }
                });

                results[0]['qrCode'] = qrCode;
                res.json(results[0]);
            }
            else
                res.json('no lesson');
        });
});

module.exports = router;
