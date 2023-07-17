import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

Widget campaignEvent({icon, String? title, int? eventIndex, Function()? onPress}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: onPress,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 220,
            margin: const EdgeInsets.all(4),          
            child: ClipRRect(borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imgCamp01,            
                fit: BoxFit.cover,
              ),
            ),
          ),
          7.heightBox,
          title!.text
              .maxFontSize(12)
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make()
        ],
      ),
    ),
  );
}
