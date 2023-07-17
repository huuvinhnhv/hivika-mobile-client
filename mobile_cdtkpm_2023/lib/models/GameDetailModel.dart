
import 'dart:convert';
import 'package:http/http.dart' as http;


GameDetail gameDetailFromJson(String str) => GameDetail.fromJson(json.decode(str));

String gameDetailToJson(GameDetail data) => json.encode(data.toJson());

class GameDetail {
    Data data;
    bool success;
    String message;

    GameDetail({
        required this.data,
        required this.success,
        required this.message,
    });

    factory GameDetail.fromJson(Map<String, dynamic> json) => GameDetail(
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
        coupons: List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
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

    Coupon({
        required this.id,
        required this.gameId,
        required this.name,
        required this.code,
    });

    factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        gameId: json["gameId"],
        name: json["name"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "name": name,
        "code": code,
    };
}



Future<GameDetail> fetchGameDetail(int gameID) async {
  final response = await http.get(Uri.parse('https://cdtkpmnc2023final.azurewebsites.net/api/Game/$gameID'));

  if (response.statusCode == 200) {
    return GameDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load game detail');
  }
}
