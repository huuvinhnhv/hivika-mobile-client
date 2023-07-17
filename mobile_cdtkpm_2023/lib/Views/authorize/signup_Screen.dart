import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_cdtkpm_2023/Controllers/auth_controller.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

import '../../consts/lists.dart';
import '../bgGround/bgIntro.dart';
import '../home_screen/home_screen.dart';
import '../homepage.dart';
import '../widgets_common/custom_filetext.dart';
import '../widgets_common/logo_app.dart';
import '../widgets_common/our_button.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  bool? isCheck = false;
  var controller = Get.put(AuthorController());
  //text controller;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgIntro(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogo(),
              10.heightBox,
              "Join the  $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                        hint: nameHint,
                        title: name,
                        controller: nameController,
                        isPass: false),
                    customTextField(
                        hint: emailHint,
                        title: email,
                        controller: emailController,
                        isPass: false),
                    customTextField(
                        hint: passwordHint,
                        title: password,
                        controller: passwordController,
                        isPass: true),
                    customTextField(
                        hint: passwordHint,
                        title: retypePassword,
                        controller: passwordRetypeController,
                        isPass: true),
                    customTextField(
                        hint: phoneNumberHint,
                        title: phoneNumber,
                        controller: phoneNumberController,
                        isPass: true),
                    Row(children: [
                      Checkbox(
                        activeColor: redColor,
                        value: isCheck,
                        checkColor: whiteColor,
                        onChanged: (newvalue) {
                          setState(() {
                            isCheck = newvalue;
                          });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(
                              fontFamily: regular,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: termAndcondition,
                            style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ),
                          ),
                          TextSpan(
                            text: "&",
                            style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ),
                          ),
                          TextSpan(
                            text: privacyPolicy,
                            style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ),
                          ),
                        ])),
                      ),
                    ]),
                    5.heightBox,
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: isCheck == true ? redColor : lightGrey,
                            title: signup,
                            textColor: whiteColor,
                            onpress: () async {
                              if (isCheck != false) {
                                controller.isLoading(true);
                                try {
                                  await controller
                                      .signupMethod(
                                          context: context,
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    return controller.storeUserData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phoneNumber: phoneNumberController.text,                                       
                                        );
                                  }).then((value) {
                                    VxToast.show(context, msg: loginSuccess);
                                    Get.offAll(() => const Home_ScreenFix());
                                  });
                                } catch (ex) {
                                  await auth.signOut();
                                  VxToast.show(context, msg: ex.toString());
                                  controller.isLoading(false);
                                }
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alreadyHaveAccount.text.color(fontGrey).make(),
                        login.text.color(redColor).make().onTap(() {
                          Get.back();
                        })
                      ],
                    ),
                  ],
                ),
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
      ),
    );
  }
}
