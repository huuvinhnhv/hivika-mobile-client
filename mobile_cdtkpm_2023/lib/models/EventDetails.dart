import 'dart:convert';
import 'package:http/http.dart' as http;



class EventDetail {
    EventDetail({
        required this.data,
        required this.success,
        required this.message,
    });

    Data data;
    bool success;
    String message;

    factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
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
    Data({
        required this.eventId,
        required this.name,
        required this.description,
        required this.startDate,
        required this.endDate,
        required this.clientId,
        required this.games,
    });

    int eventId;
    String name;
    String description;
    DateTime startDate;
    DateTime endDate;
    int clientId;
    List<Game> games;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        eventId: json["eventId"],
        name: json["name"],
        description: json["description"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        clientId: json["clientId"],
        games: List<Game>.from(json["games"].map((x) => Game.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "name": name,
        "description": description,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "clientId": clientId,
        "games": List<dynamic>.from(games.map((x) => x.toJson())),
    };
}

class Game {
    Game({
        required this.gameId,
        required this.name,
        required this.description,
    });

    int gameId;
    String name;
    String description;

    factory Game.fromJson(Map<String, dynamic> json) => Game(
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
