import 'package:flutter/material.dart';

Widget backButton(context, {Color color, Function backFun}) {
  return IconButton(
    icon: Icon(
      Icons.chevron_left,
      size: 35,
      color: color,
    ),
    onPressed: backFun ?? () => Navigator.of(context).pop(),
  );
}
