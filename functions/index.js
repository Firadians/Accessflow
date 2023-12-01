    const functions = require('firebase-functions');
    const admin = require('firebase-admin');
    admin.initializeApp();

    exports.sendNotification = functions.https.onCall(async (data, context) => {
    const { userToken, title, body } = data;

    const payload = {
        notification: {
        title: title,
        body: body,
        },
    };

    await admin.messaging().sendToDevice(userToken, payload);

    return { result: 'Notification sent successfully' };
    });
