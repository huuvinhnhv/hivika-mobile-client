import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

import '../../consts/lists.dart';
import '../../models/GameList.dart';
import 'gamDetails.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class gamePage extends StatefulWidget {
  const gamePage({Key? key}) : super(key: key);

  @override
  _gamePageState createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
  late Future<GameList> _gameListFuture;

  @override
  void initState() {
    super.initState();
    _gameListFuture = fetchGameList();
  }

  Future<GameList> fetchGameList() async {
    final response = await http.get(
        Uri.parse('https://cdtkpmnc2023final.azurewebsites.net/api/GetAllGame'));

    if (response.statusCode == 200) {
      return GameList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load game list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imgGamePage), fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          title: "ListGame".text.fontFamily(bold).white.make(),
        ),
        body: FutureBuilder<GameList>(
          future: _gameListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final gameList = snapshot.data!.data;
              return Container(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                    itemCount: gameList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              imgGameList[index],
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            10.heightBox,
                            gameList[index]
                                .name
                                .text
                                .color(redColor)
                                .align(TextAlign.center)
                                .make(),
                            5.heightBox,
                          ],
                        ),
                      )
                          .box
                          .white
                          .rounded
                          .clip(Clip.antiAlias)
                          .outerShadow
                          .make()
                          .onTap(() {
                        Get.to(() => GameDetails(
                              gameID: gameList[index].gameId,
                              title: gameList[index].name,
                              imageGame: imgGameList[index],
                            ));
                      });
                    }),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
