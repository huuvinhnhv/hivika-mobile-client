import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';

VoucherDetail voucherDetailFromJson(String str) =>
    VoucherDetail.fromJson(json.decode(str));

String voucherDetailToJson(VoucherDetail data) => json.encode(data.toJson());

class VoucherDetail {
  List<ListVoucher> data;
  bool success;
  String message;

  VoucherDetail({
    required this.data,
    required this.success,
    required this.message,
  });

  factory VoucherDetail.fromJson(Map<String, dynamic> json) => VoucherDetail(
        data: List<ListVoucher>.from(
            json["data"].map((x) => ListVoucher.fromJson(x))),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "message": message,
      };
}

class ListVoucher {
  int id;
  int gameId;
  String name;
  String code;
  String discount;
  String userId;
  ListVoucher({
    required this.id,
    required this.gameId,
    required this.name,
    required this.code,
    required this.discount,
    required this.userId,
  });

  factory ListVoucher.fromJson(Map<String, dynamic> json) => ListVoucher(
        id: json["id"],
        gameId: json["gameId"],
        name: json["name"],
        code: json["code"],
        discount: json["discount"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "name": name,
        "code": code,
        "discount": discount,
        "userId": userId,
      };
}

Future<VoucherDetail> fetchVoucherList() async {
  final response = await http.get(
      Uri.parse('https://cdtkpmnc2023final.azurewebsites.net/api/GetAllVoucher'));
  if (response.statusCode == 200) {
    return VoucherDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load event list');
  }
}
