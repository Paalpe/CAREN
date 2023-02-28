
// // const functions = require("firebase-functions");
// // const admin = require('firebase-admin')
// // import * as admin from 'firebase-admin';
// import functions from 'firebase-functions';
// import express from 'express';
// import cors from 'cors';
// import fetch from 'node-fetch';

// // admin.initializeApp()

// // // firebase deploy --only functions

// // // // Create and deploy your first functions
// // // // https://firebase.google.com/docs/functions/get-started
// // //
// // exports.helloWorld = functions.https.onRequest(async (request, response) => {
// //   functions.logger.info("Hello logs!!!", { structuredData: true });
// //   const phoneList = (await admin.auth().listUsers()).users.map((user => user.phoneNumber)).filter((phone) => phone != null);
// //   response.send(phoneList);
// // });


// // async function getAllUsers(req, res) {
// //   var allUsers = [];
// //   try {
// //     const listUsersResult = await admin.auth().listUsers();
// //     listUsersResult.users.forEach(function (userRecord) {
// //       // For each user
// //       var userData = userRecord.toJSON();
// //       allUsers.push(userData);
// //     });
// //     return JSON.stringify(allUsers)
// //     // res.status(200).send(JSON.stringify(allUsers));
// //   } catch (error) {
// //     console.log("Error listing users:", error);
// //     res.status(500).send(error);
// //   }
// // }

// // // module.exports = {
// // //   api: functions.https.onRequest(getAllUsers),
// // // };

// // exports.sendSMSFromDocument = functions.firestore
// //   .document('isAdmin/sendSMS/{docuid}')
// //   .onCreate(async (doc, context) => {
// //     const phoneList = (await admin.auth().listUsers()).users.map((user => user.phoneNumber)).filter((phone) => phone != null);
// //     response.send(phoneList);

// //   });


// const app = express();
// app.use(cors());

// app.get('/fetch-data', (req, res) => {
//   const url = 'https://itch.io/jam/328643/entries.json';
//   fetch(url)
//     .then(response => response.json())
//     .then(data => res.send(data))
//     .catch(error => res.status(500).send(error));
// });

// exports.fetchData = functions.https.onRequest(app);
const functions = require('firebase-functions')
const URL_THE_GUARDIAN = "https://www.theguardian.com/uk/london/rss"

const Client = require('node-rest-client').Client
const client = new Client()

exports.fetch = functions.https.onRequest((req, res) => {
    client.get(URL_THE_GUARDIAN, function (data, response) {
        const items = cleanUp(data)
        res.status(201)
            .type('application/json')
            .send(items)
    })
})

function cleanUp(data) {
    // Empty array to add cleaned up elements to
    const items = []
    // We are only interested in children of the 'channel' element
    const channel = data.rss.channel

    channel.item.forEach(element => {
        item = {
            title: element.title,
            description: element.description,
            date: element.pubDate,
            creator: element['dc:creator'],
            media: []
        }
        // Iterates through all the elements named '<media:content>' extracting the info we care about
        element['media:content'].forEach(mediaContent => {
            item.media.push({
                url: mediaContent.$.url,                // Parses media:content url attribute
                credit: mediaContent['media:credit']._  // Parses media:credit tag content
            })
        })
        items.push(item)
    })
    return items
}