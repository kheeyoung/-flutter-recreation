const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { FieldValue } = require("firebase-admin/firestore");
admin.initializeApp();
const db = admin.firestore();

const {onSchedule} = require("firebase-functions/v2/scheduler");

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  try {
    const { title, body, receiverId } = req.body;

    if (!title || !body || !receiverId) {
      return res.status(400).send("Missing required fields");
    }

    // Firestore에서 receiver의 FCM 토큰 찾기
    const userDoc = await admin.firestore().collection("user").doc(receiverId).get();

    if (!userDoc.exists) {
      return res.status(404).send("User not found");
    }

    const userData = userDoc.data();
    const fcmToken = userData.messageToken;

    if (!fcmToken) {
      return res.status(404).send("FCM token not found");
    }

    // 메시지 구성
    const message = {
      notification: {
        title,
        body,
      },
      token: fcmToken,
    };

    // 푸시 알림 전송
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
    return res.status(200).send("Notification sent");
  } catch (error) {
    console.error("Error sending notification:", error);
    return res.status(500).send("Internal Server Error");
  }
});

exports.makeNum=onSchedule("every day 00:00", async (event) => {
const numbers = [];
    while (numbers.length < 3) {
      const num = Math.floor(Math.random() * 10);
      if (!numbers.includes(num)) {
        numbers.push(num);
      }
    }

    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const date = now.getDate();

    const docRef = db.collection("lottery").doc(`${year}${month}${date}`);
    await docRef.set({
      num: numbers,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log("Generated numbers:", numbers);
    return null;
 });

exports.petManage = onSchedule("every day 02:05", async () => {
  const userSnap = await admin.firestore().collection("pet").get();


  await Promise.all(
    userSnap.docs.map(async (userDoc) => {
      const userId = userDoc.id;

      const petsRef = db.collection("pet").doc(userId).collection("pet");
      const petSnap = await petsRef.get();

      const livePets = petSnap.docs.filter(
        (doc) => doc.data().isDead === 0
      );
      console.log(`👤 User ${userId} has ${livePets.length} live pets`);

      for (const petDoc of livePets) {
        const data = petDoc.data();
        await petDoc.ref.update({
          fatigue: Math.max(0, data.fatigue - 40),
          happy: Math.max(0, data.happy - 40),
          hunger: Math.max(0, data.hunger - 40),
        });

      }
    })
  );

  return null;
});
