// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);
import 'dart:convert';
import 'package:http/http.dart' as http;



Client clientFromJson(String str) => Client.fromJson(json.decode(str));

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
    List<Datum> data;
    bool success;
    String message;

    Client({
        required this.data,
        required this.success,
        required this.message,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
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
    int clientId;
    String clientName;
    String address;
    String description;
    String phoneNumber;

    Datum({
        required this.clientId,
        required this.clientName,
        required this.address,
        required this.description,
        required this.phoneNumber,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["clientId"],
        clientName: json["clientName"],
        address: json["address"],
        description: json["description"],
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "clientName": clientName,
        "address": address,
        "description": description,
        "phoneNumber": phoneNumber,
    };
}
Future<Client> fetchClientList() async {
  final response = await http.get(Uri.parse('https://cdtkpmnc2023final.azurewebsites.net/api/GetAllClient'));
  if (response.statusCode == 200) {
    return Client.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load event list');
  }
}
