import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/NumConvert.dart';
import '../models/VoucherGame.dart';

class VoucherController extends GetxController {
  var isLoading = false.obs;
  RxString numRequest = "".obs;
  Rx<NumConvert?> numConvert = Rx<NumConvert?>(null);

  Future<String?> fetchNumRequest() async {
    final url = Uri.parse('https://fastapi-17sw.onrender.com/getRequestId');
    final response = await http.post(url, body: {'param1': 'value1'});
    if (response.statusCode == 200) {
      numRequest.value = response.body.substring(1, response.body.length - 1);
      return numRequest.value;
    } else {
      throw Exception('Failed to fetch num request');
    }
  }

  Future<Coupon> _updateVoucher(
      int voucherId, Map<String, dynamic> voucherData) async {
    final response = await http.put(
        Uri.parse(
            'https://cdtkpmnc2023final.azurewebsites.net/api/Voucher/$voucherId'),
        body: jsonEncode(voucherData),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return Coupon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update voucher');
    }
  }

  Future<void> _fetchVoucherGameCoupon(
      int gameId, Map<String, dynamic> voucherData) async {
    final response = await http.get(Uri.parse(
        'https://cdtkpmnc2023final.azurewebsites.net/api/Game/$gameId'));

    if (response.statusCode == 200) {
      final voucherGame = VoucherGame.fromJson(jsonDecode(response.body));
      final coupons = voucherGame.data.coupons
          .where((coupon) => coupon.discount.isEmpty)
          .toList();
      if (coupons.isNotEmpty) {
        final voucher = coupons.first;
        Map<String, dynamic> updatedVoucher = {
          "gameId": voucher.gameId,
          "name": voucher.name,
          "code": voucher.code,
          "discount": (voucherData['mappingNum'] * 5).toString(),
          "userId": voucherData['UserID'],
          "eventId": voucherData['eventId'],
        };
        await _updateVoucher(voucher.id, updatedVoucher);
      } else {
        throw Exception('No coupons found');
      }
    } else {
      throw Exception('Failed to load voucher game detail');
    }
  }

  Future<void> fetchNumConvert(String numRequest, String gameName,
      String eventName, DateTime endDate, int gameId, int eventId) async {
    final response = await http.get(Uri.parse(
        'https://fastapi-17sw.onrender.com/getRandomNumber/$numRequest'));

    if (response.statusCode == 200) {
      numConvert.value = NumConvert.fromJson(json.decode(response.body));
      String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference users = FirebaseFirestore.instance.collection('user');
      DocumentReference userDoc = users.doc(userId);

      DocumentSnapshot userSnapshot = await userDoc.get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      String username = userData!['name'];
      if (userSnapshot.exists) {
        Map<String, dynamic> voucherData = {
          'randomNum': numConvert.value!.randomNum,
          'mappingNum': numConvert.value!.mappingNum,
          'transectionLog': numConvert.value!.transectionLog,
          'UserID': userId,
          'UserName': username,
          'gameName': gameName,
          'eventName': eventName,
          'endDate': endDate,
          'eventId': eventId,
          'receivedTime': Timestamp.now()
        };

        Map<String, dynamic> historyVoucher = {
          'discount': numConvert.value!.mappingNum * 5,
          'mappingNum': numConvert.value!.mappingNum,
          'transectionLog': numConvert.value!.transectionLog,
          'gameName': gameName,
          'eventName': eventName,
          'endDate': endDate,
          'UserName': username,
          'receivedTime': Timestamp.now(),
          'isOwner': true,
        };
        await userDoc.update({
          'vouchers': FieldValue.arrayUnion([voucherData])
        });
        await userDoc.update({
          'history': FieldValue.arrayUnion([historyVoucher])
        });
        await _fetchVoucherGameCoupon(gameId, voucherData);
      } else {
        throw Exception('User document not found');
      }
    } else {
      throw Exception('Failed to fetch num conversion');
    }
  }

  void reset() {
    // Thiết lập lại toàn bộ voucherController
    isLoading = false.obs;
    numRequest = "".obs;
    numConvert = Rx<NumConvert?>(null);
  }
}
