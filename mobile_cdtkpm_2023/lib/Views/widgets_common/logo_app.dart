import 'package:flutter/widgets.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';


Widget appLogo() {
  return Image.asset(icLogo)
      .box
      .white
      .size(77, 77)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
