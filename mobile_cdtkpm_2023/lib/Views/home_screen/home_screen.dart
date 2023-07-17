import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:mobile_cdtkpm_2023/Views/TopButtonScreen/TopBrandScreen.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:mobile_cdtkpm_2023/consts/lists.dart';
import 'package:mobile_cdtkpm_2023/models/VoucherList.dart';

import '../../main.dart';
import '../../services/firebase_messaging_service.dart';
import '../Client_Screen/ClientScreen.dart';
import '../Game_Screen/game_screen.dart';
import '../Nearby_Places/findNearestPlaces.dart';
import '../widgets_common/home_button.dart';
import 'package:mobile_cdtkpm_2023/Views/Event_Screen/EventsScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  late Future<VoucherDetail> _voucherList;
  @override
  void initState() {
    super.initState();

    _voucherList = fetchVoucherList(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imghomePage), fit: BoxFit.fill)),
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: ListView(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          children: [
            //search
            Container(
              height: 50,
              alignment: Alignment.center,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: Searchbar,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
              ),
            ),
            20.heightBox,
            /* swipper brand */
            VxSwiper.builder(
                aspectRatio: 16 / 9,
                autoPlay: true,
                height: 230,
                enlargeCenterPage: true,
                itemCount: brandList.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Image.asset(
                      brandList[index],
                      fit: BoxFit.fill,
                    )
                        .box
                        .rounded
                        .clip(Clip.antiAlias)
                        .margin(const EdgeInsets.symmetric(horizontal: 8.0))
                        .make(),
                  );
                }),
            10.heightBox,
            //first button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                4,
                (index) => InkWell(
                  onTap: () {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsScreen()),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const gamePage()),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  ClientScreen()),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                        break;
                    }
                  },
                  child: homeButton(
                    width: context.screenWidth / 4.65,
                    height: context.screenHeight * 0.12,
                    icon: index == 0
                        ? icButtonHome01
                        : index == 1
                            ? icButtonHome02
                            : index == 2
                                ? icButtonHome03
                                : icButtonHome04,
                    title: index == 0
                        ? bigDiscount
                        : index == 1
                            ? topGame
                            : index == 2
                                ? topBrand
                                : nearestStore,
                  ),
                ),
              ),
            ),
            //ưu đãi mới
            10.heightBox,
            Align(
              alignment: Alignment.centerLeft,
              child: newCampaign.text
                  .color(darkFontGrey)
                  .size(15)
                  .fontFamily(semibold)
                  .make(),
            ),
            10.heightBox,
            // list voucher
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sloganVoucher.text
                      .color(const Color.fromRGBO(89, 5, 224, 1))
                      .fontFamily(dmSerif)
                      .size(22)
                      .make(),
                  20.heightBox,
                  FutureBuilder<VoucherDetail>(
                    future: _voucherList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              snapshot.data!.data.length,
                              (index) => Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(imgVoucherPink),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    4.heightBox,
                                    Text(
                                      snapshot.data!.data[index].name,
                                      style: const TextStyle(
                                        fontFamily: 'semibold',
                                        color: Color.fromARGB(255, 255, 15, 7),
                                      ),
                                    ),
                                    20.heightBox,
                                    Image.asset(
                                      IconVoucherHomePage,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    5.heightBox,
                                    Text(
                                      snapshot.data!.data[index].name,
                                      style: const TextStyle(
                                        fontFamily: 'semibold',
                                        color: Color.fromARGB(255, 255, 15, 7),
                                      ),
                                    ),
                                    10.heightBox,
                                    Text(
                                      'Code: ${snapshot.data!.data[index].code}',
                                      style: const TextStyle(
                                        fontFamily: 'semibold',
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 15,
                                      ),
                                    ),
                                    5.heightBox,
                                  ],
                                )
                                    .box
                                    .color(Colors.transparent)
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 5))
                                    .padding(const EdgeInsets.all(20))
                                    .rounded
                                    .make(),
                              )
                                  .box
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 2))
                                  .make(),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
