const qrLen = 10;
const randomstring = require("randomstring");

exports.func = function generateQRCodes ()
{
    global.connDB.query(
        'select Lesson.LessonId, S.StudentId FROM Lesson\n' +
        'join GroupLessons GL on GL.lessonId = Lesson.lessonId\n' +
        'join Student S on S.groupId = GL.groupId\n' +
        `WHERE timeStart <= \'${global.currTime}\' and timeEnd >= \'${global.currTime}\'\n` +
        'AND NOT EXISTS (SELECT * FROM StudentPresence WHERE studentId = S.studentId and lessonId = Lesson.lessonId);',
        function (error, results, fields) {
        if (error) throw error;

        global.qrArray.clear();

        results.forEach(lesson => {
            let newStr;

            do{
                newStr = randomstring.generate(qrLen);
            }while(global.qrArray.has(newStr));

            global.qrArray.set(newStr, {lessonId: lesson['LessonId'], studentId: lesson['StudentId']});
        });

        console.log(global.qrArray);
    });
}