import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/fire_storeService.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;
  late AnimationController _animationController;

  late User? currentUser = FirebaseAuth.instance.currentUser;
  double screenHeight = 0;
  double screenWidth = 0;

  bool startAnimation = false;

  @override
  void initState() {
    super.initState();
    userStream = FirestoreServices.getUser(currentUser!.uid);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF222431),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    startAnimation = true;
                  });
                  _animationController.forward(from: 0.0);
                },
                child: const Text(
                  "Transaction History",
                  style: TextStyle(
                    fontFamily:dmSerif,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: userStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Đã xảy ra lỗi: ${snapshot.error}');
                  }
                  final documents = snapshot.data!.docs;
                  final Map<String, dynamic> data = documents[0].data();
                  final List<dynamic> history = data['history'] ?? [];
                  final int itemCount = history.length;
                  final String currentUserName = data['name'] ?? '';

                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      _animationController.forward(from: 0.0);

                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final _slideAnimation = CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index + 1) * 0.1,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          );

                          return SlideTransition(
                            position: _slideAnimation.drive(
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ),
                            ),
                            child: item(index, history[index], currentUserName),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(int index, dynamic historyItem, String currentUserName) {
    String username = '';
    String eventName = '';
    String receivedTime = '';
    String endDateTime = '';
    int? discount;
    String transectionLog = '';
    final Map<String, dynamic>? historyVoucher =
        historyItem as Map<String, dynamic>?;

    if (historyVoucher != null) {
      username = historyVoucher['UserName'] ?? '';
      eventName = historyVoucher['eventName'] ?? '';
      discount = historyVoucher['discount'] ?? 0;

      transectionLog = historyVoucher['transectionLog'];
      final receivedTimestamp = historyVoucher['receivedTime'] as Timestamp?;
      final endDateTimestamp = historyVoucher['endDate'] as Timestamp?;
      if (receivedTimestamp != null && endDateTimestamp != null) {
        final receivedDateTime = receivedTimestamp.toDate();
        final formatter = DateFormat('dd.MM.yyyy HH:mm');
        receivedTime = formatter.format(receivedDateTime);

        final endDateTimes = endDateTimestamp.toDate();
        endDateTime = formatter.format(endDateTimes);
      }
    }
    final Uri _url = Uri.parse(transectionLog);
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }

    return AnimatedContainer(
      height: 160,
      width: screenWidth,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300 + (index * 200)),
      transform:
          Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Expanded(
            flex: 8, // Đặt flex của Expanded widget là 8
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: Color.fromARGB(183, 100, 222, 224).withOpacity(0.5),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        receivedTime,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                5.heightBox,
                (historyVoucher?['isOwner'] && username == currentUserName)
                    ? "${index + 1}. Bạn đã nhận được voucher từ event: $eventName, discount-$discount%"
                        .text
                        .color(Colors.black)
                        .fontWeight(FontWeight.bold)
                        .make()
                    : (historyVoucher?['isOwner'] &&
                            username != currentUserName)
                        ? "${index + 1}.Bạn đã được tặng 1 voucher từ người bạn $username từ event: $eventName, Discount-$discount%, Vào ngày: $receivedTime"
                            .text
                            .color(Colors.black)
                            .fontWeight(FontWeight.bold)
                            .make()
                        : "${index + 1}. Bạn đã ${"Gửi"} 1 voucher cho người bạn từ event: $eventName, Discount-$discount%, Vào ngày: $receivedTime"
                            .text
                            .color(Colors.black)
                            .fontWeight(FontWeight.bold)
                            .make(),
                5.heightBox,
                Text(
                  "This voucher is valid until: $endDateTime",
                  style: const TextStyle(
                    fontSize: 12,
                    color: redColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                5.heightBox,
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          "Check transaction log:"
                              .text
                              .fontFamily(semibold)
                              .make(),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                _launchUrl();
                              },
                              child: "Click Here".text.make(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          5.widthBox,
          if (historyVoucher?['isOwner'])
            Image.asset(
              IconArrowGetting,
              width: 17,
              height: 17,
            )
          else
            Image.asset(
              IconArrowLeaving,
              width: 17,
              height: 17,
            )
        ],
      ),
    );
  }
}
