const functions = require("firebase-functions");
const admin = require('firebase-admin')

admin.initializeApp()

// firebase deploy --only functions

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
exports.helloWorld = functions.https.onRequest(async (request, response) => {
  functions.logger.info("Hello logs!!!", { structuredData: true });
  const phoneList = (await admin.auth().listUsers()).users.map((user => user.phoneNumber)).filter((phone) => phone != null);
  response.send(phoneList);
});


async function getAllUsers(req, res) {
  var allUsers = [];
  try {
    const listUsersResult = await admin.auth().listUsers();
    listUsersResult.users.forEach(function (userRecord) {
      // For each user
      var userData = userRecord.toJSON();
      allUsers.push(userData);
    });
    return JSON.stringify(allUsers)
    // res.status(200).send(JSON.stringify(allUsers));
  } catch (error) {
    console.log("Error listing users:", error);
    res.status(500).send(error);
  }
}

// module.exports = {
//   api: functions.https.onRequest(getAllUsers),
// };

exports.sendSMSFromDocument = functions.firestore
  .document('isAdmin/sendSMS/{docuid}')
  .onCreate(async (doc, context) => {
    const phoneList = (await admin.auth().listUsers()).users.map((user => user.phoneNumber)).filter((phone) => phone != null);
    response.send(phoneList);

  });