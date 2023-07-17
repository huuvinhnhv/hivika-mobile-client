
import 'dart:convert';

GameList gameListFromJson(String str) => GameList.fromJson(json.decode(str));

String gameListToJson(GameList data) => json.encode(data.toJson());

class GameList {
    List<Datum> data;
    bool success;
    String message;

    GameList({
        required this.data,
        required this.success,
        required this.message,
    });

    factory GameList.fromJson(Map<String, dynamic> json) => GameList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "message": message,
    };
}

class Datum {
    int gameId;
    String name;
    String description;

    Datum({
        required this.gameId,
        required this.name,
        required this.description,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        gameId: json["gameId"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "gameId": gameId,
        "name": name,
        "description": description,
    };
}
