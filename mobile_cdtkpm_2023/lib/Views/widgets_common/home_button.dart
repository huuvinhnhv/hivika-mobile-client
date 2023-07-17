import 'package:flutter/widgets.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';
import 'package:mobile_cdtkpm_2023/consts/images.dart';

Widget homeButton({width,height,icon,String? title,onPress}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [  
  Image.asset(icon, width:35),
  10.heightBox,
  title!.text.maxFontSize(12).fontFamily(semibold).color(darkFontGrey).make()
    ],
  ).box.rounded.white.size(width, height).make();
}


