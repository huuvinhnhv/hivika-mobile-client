
import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/Controllers/homeController.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:get/get.dart';


import 'MyVoucher/myVoucherPage.dart';
import 'Profile/profile.dart';
import 'Transaction History/HistoryPage.dart';
import 'home_screen/home_screen.dart';

class Home_ScreenFix extends StatelessWidget {
  const Home_ScreenFix({super.key});
  static const home = "Home",
      Voucher = "Voucher",
      Notification = "Notification",
      owner = "Account";

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(HomeController());
    var navigationBar = [
      BottomNavigationBarItem(
          icon: Image.asset("assets/icons/home.png", width: 25), label: "Home"),
      BottomNavigationBarItem(
          icon: Image.asset("assets/icons/coupon.png", width: 25),
          label: "My Voucher"),
      BottomNavigationBarItem(
          icon: Image.asset("assets/icons/iconHistory.png", width: 25),
          label: "History"),
      BottomNavigationBarItem(
          icon: Image.asset("assets/icons/profile.png", width: 25),
          label: "Account"),
    ];
    var navBody = [
      const Home(),
      const ListVoucherUser(),
      const HistoryPage(),
      const ProfileScreen(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: navBody.elementAt(controller.currentNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          selectedItemColor: redColor,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navigationBar,
          onTap: (value) {
            controller.currentNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
