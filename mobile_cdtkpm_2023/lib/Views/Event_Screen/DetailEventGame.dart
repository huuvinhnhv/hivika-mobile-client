import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'dart:convert';

import '../../GameFlap/GameFlap.dart';
import '../../GamePacMan/PacMan.dart';
import '../../consts/lists.dart';
import '../../models/EventDetails.dart';
import '../Game_Screen/gamDetails.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;
  final int indexEvent;

  const EventDetailScreen({
    Key? key,
    required this.eventId,
    required this.indexEvent,
  }) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Future<EventDetail> _eventDetailFuture;

  @override
  void initState() {
    super.initState();
    _eventDetailFuture = _fetchEventDetail();
  }

  Future<EventDetail> _fetchEventDetail() async {
    final response = await http.get(Uri.parse(
        'https://cdtkpmnc2023final.azurewebsites.net/api/Event/${widget.eventId}'));

    if (response.statusCode == 200) {
      return EventDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load event detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BgDetailEventPage), fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event Detail'),
        ),
        body: Container(
          // padding: const EdgeInsets.all(20),
          color: whiteColor,
          child: FutureBuilder<EventDetail>(
            future: _eventDetailFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final eventDetail = snapshot.data!;
                final startDate =
                    DateFormat('dd/MM/yyyy').format(eventDetail.data.startDate);
                final endDate =
                    DateFormat('dd/MM/yyyy').format(eventDetail.data.endDate);
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        brandList[widget.indexEvent],
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                      5.heightBox,
                      Text(
                        eventDetail.data.name,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      10.heightBox,
                      Align(
                          alignment: Alignment.centerLeft,
                          child: "Thể Lệ"
                              .text
                              .fontWeight(FontWeight.bold)
                              .color(Colors.pink)
                              .size(18)
                              .align(TextAlign.start)
                              .make()),
                      const SizedBox(height: 16.0),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: eventDetail.data.description.text
                            .fontFamily(regular)
                            .size(17)
                            .make(),
                      ).box.color(whiteColor).shadowSm.make(),
                      const SizedBox(height: 16.0),
                      5.heightBox,
                      "Thời gian Sự kiện"
                          .text
                          .size(17)
                          .color(Colors.pink)
                          .make(),
                      "$startDate - $endDate"
                          .text
                          .color(redColor)
                          .size(20)
                          .make(),
                      10.heightBox,
                      //List game of event
                      const Text(
                        'Danh Sách Games Của Event',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: eventDetail.data.games
                              .asMap()
                              .map(
                                (index, game) => MapEntry(
                                  index,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      width: 250.0,
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            game.name,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 25,
                                              fontFamily: dmSerif,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GameDetails(
                                                    gameID: game.gameId,
                                                    title: game.name,
                                                    imageGame:
                                                        imgGameList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                imgGameList[index],
                                                width: double.infinity,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (game.name == "PacMan" || game.name == "Đặt Boom") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GamePacMan(
                                                      EventName:
                                                          eventDetail.data.name,
                                                      eventId: eventDetail
                                                          .data.eventId,
                                                      gameName: game.name,
                                                      endDate: eventDetail
                                                          .data.endDate,
                                                      gameId: game.gameId,
                                                    ),
                                                  ),
                                                );
                                              } else if (game.name ==
                                                  "Flappy Bird" || game.name =="Roll The Dice") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyGame(
                                                      eventName:
                                                          eventDetail.data.name,
                                                      gameName: game.name,
                                                      endDate: eventDetail
                                                          .data.endDate,
                                                      gameId: game.gameId,
                                                      eventId: eventDetail.data.eventId,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              elevation: 5,
                                            ),
                                            child: const Text(
                                              'Play Now!!',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
