
import 'dart:convert';
import 'package:http/http.dart' as http;

NumConvert numConvertFromJson(String str) => NumConvert.fromJson(json.decode(str));

String numConvertToJson(NumConvert data) => json.encode(data.toJson());

class NumConvert {
    String randomNum;
    int mappingNum;
    String transectionLog;

    NumConvert({
        required this.randomNum,
        required this.mappingNum,
        required this.transectionLog,
    });

    factory NumConvert.fromJson(Map<String, dynamic> json) => NumConvert(
        randomNum: json["randomNum"],
        mappingNum: json["mappingNum"],
        transectionLog: json["transectionLog"],
    );

    Map<String, dynamic> toJson() => {
        "randomNum": randomNum,
        "mappingNum": mappingNum,
        "transectionLog": transectionLog,
    };
}

