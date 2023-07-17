import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

import '../../models/GameDetailModel.dart';
import '../widgets_common/our_button.dart';

//test
class GameDetails extends StatefulWidget {
  final int gameID;
  final String? title;
  final String? imageGame;

  const GameDetails(
      {Key? key,
      required this.gameID,
      required this.title,
      required this.imageGame})
      : super(key: key);

  @override
  _GameDetailsState createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  late GameDetail gameDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGameDetail(widget.gameID).then((data) {
      setState(() {
        gameDetail = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imgDetailsGame), fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.make(),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
          ],
        ),
        body: Center(
          child: Stack(
            children: [
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                150.heightBox,
                                ClipOval(
                                  child: Image.asset(
                                    widget.imageGame!,
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            5.heightBox,
                            "Thông Tin Chung"
                                .text
                                .white
                                .fontFamily(semibold)
                                .size(18)
                                .make(),
                            5.heightBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gameDetail.data.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                10.heightBox,
                                Text(
                                  gameDetail.data.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: whiteColor,
                                  ),
                                ),
                                10.heightBox,
                                Text(
                                  gameDetail.data.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),              
            ],
          ),
        ),
      ),
    );
  }
}
