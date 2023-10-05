import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/services/device_manager.dart';

class TextUtils{
  static double getFontSize(ObjectSize size, {BuildContext? context}){
    //Try to get context
    BuildContext? currentContext;
    if(context != null){
      currentContext = context;
    } else if(gNavigatorStateKey.currentContext != null){
      currentContext = gNavigatorStateKey.currentContext;
    }

    if(currentContext != null){
      DeviceView view = DeviceManager().getDeviceView(currentContext);
      switch(size){
        case ObjectSize.big:
          return view == DeviceView.expanded ? 25 : 20;
        case ObjectSize.normal:
          return view == DeviceView.expanded ? 18 : 15;
        case ObjectSize.small:
          return view == DeviceView.expanded ? 15 : 12;
      }
    }
    return 0;
  }

  static bool validateEmail(String? value) {
    if(value != null){
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value) || value.length > 320)
      {
        return false;
      }
      return true;
    }
    return false;
  }

  static bool validateUsername(String? value) {
    if(value != null){
      String pattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value) || value.length > 50)
      {
        return false;
      }
      return true;
    }
    return false;
  }

  static List<String?> captureStrings(String input) {
    var re = RegExp(r'==([^]*?)==');
    List<String?> match = re.allMatches(input).map((m) => m.group(0)).toList();
    return match;
  }

  static T? enumFromString<T>(Iterable<T> values, String value) {
    String enumString = value;
    if(value.contains('.')){
      enumString = enumString.split('.').last;
    }
    return values.firstWhereOrNull((type) => type.toString().split('.').last == enumString);
  }

  static String stringFromEnum<T>(T value){
    String valueStr = value.toString();
    return valueStr.split('.').last;
  }

  static bool containsNumbers(String str){
    return str.contains(RegExp(r'[0-9]'));
  }

  static bool parseBool(String boolStr){
    return boolStr.toLowerCase() == 'true' ? true : false;
  }

  static int getIntFromString(String numStr){
    int price = int.parse(numStr.replaceAll(RegExp(r'[^0-9]'),''));
    return price;
  }

  static List<String> getStringLines(String text, TextPainter textPainter, double width){
    List<String> strLines = [];
    textPainter.layout(maxWidth: width);
    List<LineMetrics> lines = textPainter.computeLineMetrics();
    for(int idxLine = 0; idxLine < lines.length; idxLine++){
      LineMetrics line = lines[idxLine];
      var startPosition = textPainter.getPositionForOffset(Offset(line.left, line.baseline));
      var endPosition = textPainter.getPositionForOffset(Offset(line.left + line.width, line.baseline));
      var substr = text.substring(startPosition.offset, endPosition.offset);
      strLines.add(substr);
    }
    return strLines;
  }
}