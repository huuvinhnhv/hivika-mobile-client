import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_cdtkpm_2023/Controllers/auth_controller.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:mobile_cdtkpm_2023/services/fire_storeService.dart';

import '../../consts/lists.dart';
import '../Splash_screen/spl_introfix.dart';
import '../authorize/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      color: whiteColor,
      child: Scaffold(
          backgroundColor: const Color.fromARGB(162, 179, 74, 240),
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
                var name = data['name'];
                int avatarIndex = 0;
                if (name == 'hien pham') {
                  avatarIndex = 0;
                } else if (name == 'Khang Designer') {
                  avatarIndex = 2;
                } else if (name == 'Vinh BlockChain') {
                  avatarIndex = 1;
                } else {
                  avatarIndex = 3;
                }
                var countVoucher = vouchers.length;
                return SafeArea(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            bgPerson[avatarIndex],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 2,
                            bottom: 10,
                            child: Image.asset(avatarPerson[avatarIndex],
                                    width: 100, height: 100, fit: BoxFit.cover)
                                .box
                                .roundedFull
                                .clip(Clip.antiAlias)
                                .make(),
                          ),                   
                          Positioned(
                            right: 4,
                            top: 10,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Get.delete<
                                    AuthorController>(); // Xóa dữ liệu của AuthorController
                                Get.offAll(() => const Spl_intro_fix());
                              },
                              child: "Logout"
                                  .text
                                  .white
                                  .fontFamily(semibold)
                                  .make(),
                            ),
                          )
                        ],
                      ),
                      30.heightBox,
                      Container(
                        padding: const EdgeInsets.all(3),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                data['name'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                data['email'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Phone',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                data['phoneNumber'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.confirmation_number,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Your voucher quantity',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                countVoucher.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .box
                          .width(context.screenWidth - 50)
                          .shadowSm
                          .rounded
                          .color(lightGrey)
                          .make(),
                    ],
                  ),
                );
              }
            },
          )),
    );
  }
}
