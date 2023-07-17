import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

Widget ourButton({onpress, color, textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onpress,
    child: title!.text.color(textColor).fontFamily(bold).make(),
  );
}
