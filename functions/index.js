// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
// // // firebase deploy --only functions

// // // // Create and deploy your first functions
// // // // https://firebase.google.com/docs/functions/get-started
// // //
exports.helloWorld = functions.https.onRequest(async (request, response) => {
    if (request.headers.authorization !== 'Bearer ' + process.env.GETPHONETOKEN)
        throw new Error('Unauthorized');


    functions.logger.info("Hello logs!!!", { structuredData: true });
    const phoneList = (await admin.auth().listUsers()).users.map((user => user.phoneNumber)).filter((phone) => phone != null);
    response.json({ phoneList: phoneList });
});



exports.helloWorldMail = functions.https.onRequest(async (request, response) => {
    if (request.headers.authorization !== 'Bearer ' + process.env.PASSORDEPOST)
        throw new Error('Unauthorized');


    functions.logger.info("Hello logs!!!", { structuredData: true });
    const mailList = (await admin.auth().listUsers()).users.map((user => user.email)).filter((mail) => mail != null);
    response.json({ mailList: mailList });
});

// exports.getAllUsersPhone = functions.https.onRequest(async (req, res) => {
//     // check for authentification in header
//    if (req.headers.authorization === 'Bearer ' + process.env.GETPHONETOKEN)
//    throw new Error('Unauthorized');



//     var allUsers = [];
//     try {
//         const listUsersResult = await admin.auth().listUsers();
//         listUsersResult.users.forEach(function (userRecord) {
//             // For each user
//             var userData = userRecord.toJSON();
//             allUsers.push(userData);
//         });
//         return JSON.stringify(allUsers)
//         // res.status(200).send(JSON.stringify(allUsers));
//     } catch (error) {
//         console.log("Error listing users:", error);
//         res.status(500).send(error);
//     }
// });

