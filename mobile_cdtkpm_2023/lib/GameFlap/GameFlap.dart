// // ignore_for_file: prefer_const_constructors, unnecessary_import, unused_local_variable


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Layouts/Pages/page_start_screen.dart';
import 'Resources/strings.dart';
import 'Routes/app_routes.dart';
import 'gameController.dart';




class MyGame extends StatefulWidget {
  final int? score;
  final int gameId;
  final int eventId;
  final String gameName;
  final String eventName;
  final DateTime endDate;

  const MyGame({
    Key? key,
    this.score,
    required this.gameId,
    required this.eventId,
    required this.gameName,
    required this.eventName,
    required this.endDate,
  }) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Truy cập instance của GameController
    final gameController = GameController.instance;

    // Cập nhật giá trị các biến toàn cục trong GameController bằng các giá trị từ các biến tham số
    gameController.updateVariables(
      score: widget.score,
      gameId: widget.gameId,
      eventId: widget.eventId,
      gameName: widget.gameName,
      eventName: widget.eventName,
      endDate: widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: Str.home,
      onGenerateRoute: AppRoute().generateRoute,
    );
  }
}




