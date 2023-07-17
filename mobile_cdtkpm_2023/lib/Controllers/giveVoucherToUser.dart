import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addVoucherToUser(
    String phoneNumber, Map<String, dynamic> voucherGift) async {
  final userQuerySnapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('phoneNumber', isEqualTo: phoneNumber)
      .get();
  final userDocumentSnapshot = userQuerySnapshot.docs.first;
  Map<String, dynamic> newVoucherGift = {
          'discount': voucherGift['mappingNum']*5,
          'mappingNum': voucherGift['mappingNum'],
          'transectionLog': voucherGift['transectionLog'],
          'gameName': voucherGift['gameName'],
          'eventName': voucherGift['eventName'],
          'endDate': voucherGift['endDate'],
          'UserName': voucherGift['UserName'],
          'receivedTime': Timestamp.now(),
          'isOwner':true,
        };

  // Add voucher to user's vouchers array
  await userDocumentSnapshot.reference.update({
    'vouchers': FieldValue.arrayUnion([voucherGift])
  });
  await userDocumentSnapshot.reference.update({
    'history': FieldValue.arrayUnion([newVoucherGift])
  });

  // Remove voucher from currentUser's vouchers array
  final currentUser = FirebaseAuth.instance.currentUser;
  final currentUserSnapshot = await FirebaseFirestore.instance
      .collection('user')
      .doc(currentUser!.uid)
      .get();
  final currentUserVouchers =
      List.from(currentUserSnapshot.data()!['vouchers']);

  final currentUserHistory = List.from(currentUserSnapshot.data()!['history']);

  // Find the index of the voucher we want to remove
  final voucherIndex = currentUserVouchers.indexWhere(
      (voucher) => voucher['randomNum'] == voucherGift['randomNum']);

  // If the voucher is found, remove it from the array and update the user's document
  if (voucherIndex != -1) {
    currentUserVouchers.removeAt(voucherIndex);
    await currentUserSnapshot.reference
        .update({'vouchers': currentUserVouchers});

    newVoucherGift['isOwner'] = false;
    currentUserHistory.add(newVoucherGift);
     await currentUserSnapshot.reference
        .update({'history': currentUserHistory});
  }
}
