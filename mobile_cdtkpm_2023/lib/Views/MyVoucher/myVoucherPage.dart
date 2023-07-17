import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:mobile_cdtkpm_2023/services/fire_storeService.dart';

import '../../Controllers/giveVoucherToUser.dart';
import '../../consts/lists.dart';
import '../homepage.dart';

class ListVoucherUser extends StatefulWidget {
  const ListVoucherUser({super.key});

  @override
  State<ListVoucherUser> createState() => _ListVoucherUserState();
}

class _ListVoucherUserState extends State<ListVoucherUser> {
  late Stream<QuerySnapshot> userStream;
  late User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    userStream = FirestoreServices.getUser(currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BgMyVoucherPage), fit: BoxFit.fill)),
      padding: const EdgeInsets.all(12),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Voucher'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home_ScreenFix()),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: userStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              var vouchers = data['vouchers'] as List<dynamic>;
              var countVoucher = vouchers.length;
              return SafeArea(
                child: ListView.builder(
                  itemCount: countVoucher,
                  itemBuilder: (BuildContext context, int index) {
                    var voucher = vouchers[index];
                    var discount = voucher['mappingNum'] * 5;
                    var eventName = voucher['eventName'];
                    var endDate = DateFormat('dd/MM/yyyy')
                        .format(voucher['endDate'].toDate());                    
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(imgMyVoucher),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            15.widthBox,
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "$discount % OFF"
                                      .text
                                      .fontFamily(dmSerif)
                                      .color(whiteColor)
                                      .fontWeight(FontWeight.bold)
                                      .size(30)
                                      .make(),
                                ],
                              ),
                            ),
                            5.heightBox,
                            Expanded(
                              flex: 7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    eventName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  5.heightBox,
                                  "Gift Voucher"
                                      .text
                                      .color(Colors.white)
                                      .fontFamily(dmSerif)
                                      .fontWeight(FontWeight.bold)
                                      .size(20)
                                      .make(),
                                  5.heightBox,
                                  "Valid until $endDate"
                                      .text
                                      .color(whiteColor)
                                      .make(),
                                  5.heightBox,
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String phoneNumber = '';
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    bool isLoading = false;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Enter your friend\'s phone number',
                                                ),
                                                onChanged: (value) {
                                                  phoneNumber = value;
                                                },
                                              ),
                                              if (isLoading)
                                                CircularProgressIndicator(),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      await addVoucherToUser(
                                                        phoneNumber,
                                                        voucher,
                                                      );
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                              child: const Text('Add voucher'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              child: const Text(
                                'Give',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
