
import 'dart:convert';

import 'package:http/http.dart' as http;

VoucherGame voucherGameFromJson(String str) =>
    VoucherGame.fromJson(json.decode(str));

String voucherGameToJson(VoucherGame data) => json.encode(data.toJson());

class VoucherGame {
  Data data;
  bool success;
  String message;

  VoucherGame({
    required this.data,
    required this.success,
    required this.message,
  });

  factory VoucherGame.fromJson(Map<String, dynamic> json) => VoucherGame(
        data: Data.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "success": success,
        "message": message,
      };
}

class Data {
  int gameId;
  String name;
  String description;
  List<Coupon> coupons;

  Data({
    required this.gameId,
    required this.name,
    required this.description,
    required this.coupons,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        gameId: json["gameId"],
        name: json["name"],
        description: json["description"],
        coupons:
            List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gameId": gameId,
        "name": name,
        "description": description,
        "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
      };
}

class Coupon {
  int id;
  int gameId;
  String name;
  String code;
  String discount;
  String userId;
  int eventId;

  Coupon({
    required this.id,
    required this.gameId,
    required this.name,
    required this.code,
    required this.discount,
    required this.userId,
    required this.eventId,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        gameId: json["gameId"],
        name: json["name"],
        code: json["code"],
        discount: json["discount"],
        userId: json["userId"],
        eventId: json["eventId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "name": name,
        "code": code,
        "discount": discount,
        "userId": userId,
        "eventId": eventId,
      };
}
