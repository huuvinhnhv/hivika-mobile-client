import 'package:flutter/material.dart';
import 'HomePage.dart';

class GamePacMan extends StatelessWidget {
  final int gameId;
  final String gameName;
  final String EventName;
  final DateTime endDate;
  final int eventId;
  const GamePacMan({
    Key? key,
    required this.gameId,
    required this.gameName,
    required this.EventName,
    required this.eventId,
    required this.endDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
          gameName: gameName,
          eventName: EventName,
          endDate: endDate,
          gameId: gameId,
          eventId: eventId,
          ),
    );
  }
}
