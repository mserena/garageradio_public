import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/utils/text_utils.dart';

// Colors
const Color defBackgroundColor = Color(0xFF27274b);
const Color defBackgroundNotificationColorBegin = Color(0xfffeb250);
const Color defBackgroundNotificationColorEnd = Color(0xfffe8550);
const Color defTextColor = Colors.white;
const Color defSecondaryTextColor = Color(0xFF8884c1);
const Color defBackgroundColor1Begin = Color(0xffff5ea2);
const Color defBackgroundColor1End = Color(0xff8d66fd);
const Color defBackgroundColor2Begin = Color(0xffc443ff);
const Color defBackgroundColor2End = Color(0xffb34afe);
const Color defWaveBackgroundColor = Color(0x32ffffff);

// Sizes & Spaces
const double defMinExpandedViewWidth = 715;
const double defMinExpandedViewHeigth = 550;
const double defTopBarHeigth = 70;
const double defBubbleCompactSize = 100;
const double defBubbleExtendedSize = 150;
const double defMaxPlayerWidth = 500;

// Default images
const String defBubbleImage = 'assets/images/ui/default_radio_icon.png';
const String defAppIcon = 'assets/images/ui/wave_icon.png';

// Theme
ThemeData garageRadioTheme(BuildContext context){
  //TextTheme
  TextTheme garageRadioTextTheme(TextTheme base){
    return base.copyWith(
      bodyMedium: TextStyle(
        fontSize: TextUtils.getFontSize(ObjectSize.normal, context: context),
        fontFamily: 'Lexend-Regular',
        color: defSecondaryTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: TextUtils.getFontSize(ObjectSize.normal, context: context),
        fontFamily: 'Lexend-Regular',
        color: defTextColor,
      )
    );
  }

  ColorScheme garageRadioColorSheme(ColorScheme base){
    return base.copyWith(
      background: defBackgroundColor,
    );
  }

  //ThemeData
  final ThemeData garageRadioTheme = ThemeData.dark();

  return garageRadioTheme.copyWith(
    textTheme: garageRadioTextTheme(garageRadioTheme.textTheme),
    colorScheme: garageRadioColorSheme(garageRadioTheme.colorScheme),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: defBackgroundColor
  );
}

