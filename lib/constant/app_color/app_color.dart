import 'package:flutter/material.dart';

class AppColor {
  // Black Shades
  static const Color blackShade1 = Color(0xFF1E1E1E);
  static const Color blackShade2 = Color(0xFF0A0A0A);
  static const Color blackShade3 = Color(0xFF1A1A1A);
  static const Color blackColor1 = Color(0xff000000);

  // Primary Accent (was brown — now pure black)
  static const Color brownAccentPrimary = Color(0xFF111111);
  static const Color brownAccentDark = Color(0xFF000000);

  // Neutral Colors
  static const Color neutral1 = Color(0xFFF2F2F2);
  static const Color neutral2 = Color(0xFFFAFAFA);

  // Gray Shades
  static const Color primaryGrey = Color(0xFF3C3C3C);
  static const Color darkGray = Color(0xFF555555);
  static const Color coolGrayText = Color(0xFF6B7280);
  static const Color grey1Color = Color(0xff4C4546);
  static const Color grey2Color = Color(0xff555555);
  static const Color grey3Color = Color(0xff444444);

  // Light gray colors
  static const Color lightGreyColor = Color(0xffEAEAEA);
  static const Color lightGrey2Color = Color(0xffF5F3F6);

  // Shadow
  static const Color shadowGrey = Color(0xFFEEEBEE);

  // Accent colors — replaced with greyscale equivalents
  static const Color blueColor = Color(0xFF3C3C3C);      // was blue, now dark grey
  static const Color brownColor = Color(0xFF555555);     // was amber, now mid grey
  static const Color purpleColor = Color(0xFF555555);    // was purple, now mid grey

  // Button colors
  static const Color blackColor = Color(0xff111111);
  static const Color blackColor2 = Color(0xff1A1C1C);

  // Background gradient — pure white / light grey tones
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffFFFFFF),
      Color(0xffF5F5F5),
      Color(0xffF0F0F0),
      Color(0xffF5F5F5),
      Color(0xffFFFFFF),
    ],
    stops: [
      0.0,
      0.4,
      0.6,
      0.8,
      1.0,
    ],
  );

  // Home screen background gradient — white/light grey
  static const LinearGradient homeScreenBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffE8E8E8),
      Color(0xffE8E8E8),
      Color(0xffFAFAFA),
      Color(0xffFAFAFA),
      Color(0xffFAFAFA),
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 1.0],
  );

  // Subscription card gradient — dark black tones
  static const LinearGradient subscriptionCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff2C2C2C),
      Color(0xff1A1A1A),
      Color(0xff0A0A0A),
    ],
  );

  static const Color borderColor = Color(0xff777777);
  static const Color darkBrown = Color(0xff111111);      // was dark brown, now near-black
  static const Color greenColor = Color(0xff34C759);     // kept — status/success indicator
  static const Color green2Color = Color(0xff229D4F);    // kept — status/success indicator
  static const Color lightGreen1Color = Color(0xffDBF4E4); // kept — success background tint
}
