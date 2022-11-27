var express = require('express');
var router = express.Router();

var jsonParser = express.json();

router.get('/', jsonParser, function(req, res, next) {
    if(req.body['id'] === undefined) {
        res.sendStatus(500);
    }
    else {

        let currTime = global.currTime;

        global.connDB.query(
            'select Lesson.name, Lesson.timeStart, Lesson.timeEnd, Lesson.location, Lesson.isOnline,\n' +
            'T.name as tName, T.surname as tSurname, T.patronymic as tPatronymic,\n' +
            'G.name as gName FROM Lesson\n' +
            `LEFT join Student S on studentId = ${req.body['id']}\n` +
            'RIGHT join `Group` G on G.groupId = S.groupID\n' +
            'LEFT join GroupLessons GL on GL.groupId = G.groupId\n' +
            'LEFT join Teacher T on Lesson.teacherId = T.teacherId\n' +
            `WHERE Lesson.timeStart <= \'${currTime}\' and \'${currTime}\' <= Lesson.timeEnd and GL.lessonId = Lesson.lessonId`,
            function (error, results, fields) {
                if (error) throw error;

                if (results[0] !== undefined) {
                    let qrCode;

                    global.qrArray.forEach((who, qr) => {
                        if (who['studentId'] == req.body['id']) {
                            qrCode = qr;
                            return true
                        }
                    });


                    if(results[0]['isOnline'] == 1) {
                        results[0]['url'] = results[0]['location'];
                        delete results[0]['location'];
                    }
                    delete results[0]['isOnline'];

                    results[0]['qrCode'] = qrCode;
                    res.json(results[0]);
                } else
                    res.json('no lesson');
            });
    }
});

module.exports = router;
