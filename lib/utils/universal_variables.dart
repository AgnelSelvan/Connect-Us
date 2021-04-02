import 'package:flutter/material.dart';

class Variables {
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff19191b);
  static final Color greenColor = Color(0xff28AB87);
  static final Color lightGreenColor = Color(0xff7fffd4);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Color(0xff7fffd4);
  static final Color gradientColorEnd = Color(0xff28AB87);

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);

  static final TextStyle inputLabelTextStyle =
      TextStyle(fontSize: 16, color: Color(0xff777777), letterSpacing: 0.5);
  static final TextStyle inputTextStyle =
      TextStyle(fontSize: 16, letterSpacing: 0.5, color: Color(0xff333333));

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}
