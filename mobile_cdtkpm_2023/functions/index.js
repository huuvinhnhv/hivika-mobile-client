const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyOnVoucherChange = functions.firestore
  .document("user/{userId}")
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();

    const newHistory = newData.vouchers;
    const previousHistory = previousData.vouchers;
    if (newHistory !== previousHistory) {
      const message = {
        notification: {
          title: "Thông báo mới",
          body: "Danh Sách voucher của bạn đã thay đổi",
        },
        token: newData.tokenFCM, // Token đăng ký FCM của thiết bị
      };
      try {
        const response = await admin.messaging().send(message);
      } catch (error) {
        console.log(error);
      }
    }
  });
