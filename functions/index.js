const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
 exports.helloWorld = functions.https.onRequest((request, response) => {
        response.send("Hello from Firebase!");
        });
 exports.onUploadPost = functions.firestore
   .document('/post/{userId}/usersPosts/{postId}')
   .onCreate(async (snapshot, context) => {
     console.log(snapshot.data());
     const userId = context.params.userId;
     const postId = context.params.postId;
     const userFollowersRef = admin
       .firestore()
       .collection('followers')
       .doc(userId)
       .collection('userFollowers');
     const userFollowersSnapshot = await userFollowersRef.get();
     userFollowersSnapshot.forEach(doc => {
       admin
         .firestore()
         .collection('feeds')
         .doc(doc.id)
         .collection('userFeed')
         .doc(postId)
         .set(snapshot.data());
     });
   })