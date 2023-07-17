import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:mobile_cdtkpm_2023/models/Clients.dart';

import '../../consts/lists.dart';

class ClientScreen extends StatefulWidget {
  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late Future<Client> _clientListFuture;

  @override
  void initState() {
    super.initState();
    _clientListFuture = fetchClientList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgClientPage),
              fit: BoxFit.fill,
            ),
          ),
      child: Scaffold(
        appBar: AppBar(
          title: "Popular brands".text.make(),
        ),
        body: FutureBuilder<Client>(
          future: _clientListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final clientList = snapshot.data!.data;
              return ListView.builder(
                itemCount: clientList.length,
                itemBuilder: (context, index) {
                  final client = clientList[index];
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      height: 285,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 50,
                                  child: SizedBox(
                                    height: 250,
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 194, 194, 170),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                client.clientName.text
                                                    .align(TextAlign.center)
                                                    .color(Colors.purple)
                                                    .size(18)
                                                    .fontFamily(Sigmar_Regular)
                                                    .make(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: List.generate(
                                                    5,
                                                    (index) => const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: client.description.text.size(17).fontFamily(DancingScript_Regular).align(TextAlign.right).make(),
                                              // Text(
                                              //   client.description,
                                              //   textAlign: TextAlign.right,
                                              // ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  top: 20,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage(imgClientList[index]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
