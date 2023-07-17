import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_cdtkpm_2023/Controllers/auth_controller.dart';
import 'package:mobile_cdtkpm_2023/Views/authorize/signup_Screen.dart';
import 'package:mobile_cdtkpm_2023/Views/widgets_common/custom_filetext.dart';
import 'package:mobile_cdtkpm_2023/Views/widgets_common/our_button.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import '../../consts/lists.dart';
import '../bgGround/bgIntro.dart';
import '../widgets_common/logo_app.dart';
import '../homepage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controlle = Get.put(AuthorController());
    return bgIntro(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          (context.screenHeight * 0.1).heightBox,
          appLogo(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          15.heightBox,
          Obx(
            () => Column(
              children: [
                customTextField(
                    hint: emailHint,
                    title: email,
                    isPass: false,
                    controller: controlle.emailController),
                customTextField(
                    hint: passwordHint,
                    title: password,
                    isPass: true,
                    controller: controlle.passwordController),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: foregetPassword.text.make())),
                5.heightBox,
                controlle.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : ourButton(
                        color: redColor,
                        title: login,
                        textColor: whiteColor,
                        onpress: () async {
                          controlle.isLoading(true);

                          await controlle
                              .loginMethod(context: context)
                              .then((value) {
                            if (value != null) {
                              VxToast.show(context, msg: loginSuccess);
                              Get.offAll(() => const Home_ScreenFix());
                            } else {
                              controlle.isLoading(false);
                            }
                          });
                        }).box.width(context.screenWidth - 50).make(),
                5.heightBox,
                createNewAccount.text.color(fontGrey).make(),
                5.heightBox,
                ourButton(
                    color: Colors.yellow,
                    title: signup,
                    textColor: redColor,
                    onpress: () {
                      Get.to(() => const SignUp_Screen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                loginWith.text.color(fontGrey).make(),
                5.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: lightGrey,
                              radius: 30,
                              child: Image.asset(socialIconList[index]),
                            ),
                          )),
                )
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make(),
          ),
        ]),
      ),
    ));
  }
}
