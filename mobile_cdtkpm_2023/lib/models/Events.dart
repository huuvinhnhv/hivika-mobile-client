import 'dart:convert';
import 'package:http/http.dart' as http;



EventList eventListFromJson(String str) => EventList.fromJson(json.decode(str));

String eventListToJson(EventList data) => json.encode(data.toJson());

class EventList {
    EventList({
        required this.data,
        required this.success,
        required this.message,
    });

    List<Datum> data;
    bool success;
    String message;

    factory EventList.fromJson(Map<String, dynamic> json) => EventList(
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
    Datum({
        required this.eventId,
        required this.name,
        required this.description,
        required this.startDate,
        required this.endDate,
        required this.clientId,
    });

    int eventId;
    String name;
    String description;
    DateTime startDate;
    DateTime endDate;
    int clientId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        eventId: json["eventId"],
        name: json["name"],
        description: json["description"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        clientId: json["clientId"],
    );

    Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "name": name,
        "description": description,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "clientId": clientId,
    };
}
Future<EventList> fetchEventList() async {
  final response = await http.get(Uri.parse('https://cdtkpmnc2023final.azurewebsites.net/api/Event'));
  if (response.statusCode == 200) {
    return EventList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load event list');
  }
}
