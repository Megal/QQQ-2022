const qrLen = 10;
const randomstring = require("randomstring");

exports.func = function generateQRCodes ()
{
    global.connDB.query(
        'select Lesson.LessonID, S.StudentID FROM Lesson\n' +
        'join GroupLessons GL on GL.LessonID = Lesson.LessonID\n' +
        'join Student S on S.GroupID = GL.GroupID\n' +
        `WHERE TimeStart <= \'${global.currTime}\' and TimeEnd >= \'${global.currTime}\';`,
        function (error, results, fields) {
        if (error) throw error;

        global.qrArray.clear();

        results.forEach(lesson => {
            let newStr;

            do{
                newStr = randomstring.generate(qrLen);
            }while(global.qrArray.has(newStr));

            global.qrArray.set(newStr, {lessonID: lesson['LessonID'], studentID: lesson['StudentID']});
        });
    });
}