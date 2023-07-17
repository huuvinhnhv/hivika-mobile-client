import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../../consts/firebase_const.dart';
import '../../consts/images.dart';
import '../authorize/login_screen.dart';
import '../home_screen/home_screen.dart';
import '../homepage.dart';


class Spl_intro_fix extends StatefulWidget {
  const Spl_intro_fix({Key? key}) : super(key: key);

  @override
  _Spl_intro_fixState createState() => _Spl_intro_fixState();
}

class _Spl_intro_fixState extends State<Spl_intro_fix> {
  changeScreen() async {
    Future.delayed(const Duration(seconds: 5), () {
      auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        Get.to(() => const LoginScreen());
      } else {
        Get.to(() => const Home_ScreenFix());
      }
    });
    });
    
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedSplashScreen(
      splash: Lottie.asset(videoInTro),
      backgroundColor: Colors.purple,
      nextScreen: const LoginScreen(),
      splashIconSize: screenHeight,
      duration: 4500,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
