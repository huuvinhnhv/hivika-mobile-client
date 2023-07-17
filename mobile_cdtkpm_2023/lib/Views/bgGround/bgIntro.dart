import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/consts/images.dart';

Widget bgIntro({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(imgIntro),fit: BoxFit.fill)),
    child:child ,
  );
}
