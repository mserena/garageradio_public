import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/services/device_manager.dart';

class ImageUtils{
  static double getIconSize(ObjectSize size, {BuildContext? context}){
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
          return view == DeviceView.expanded ? 40 : 35;
        case ObjectSize.normal:
          return view == DeviceView.expanded ? 35 : 30;
        case ObjectSize.small:
          return view == DeviceView.expanded ? 30 : 25;
      }
    }
    return 0;
  }

  static Size getFlagSize(ObjectSize size, {BuildContext? context}){
    //Try to get context
    BuildContext? currentContext;
    if(context != null){
      currentContext = context;
    } else if(gNavigatorStateKey.currentContext != null){
      currentContext = gNavigatorStateKey.currentContext;
    }

    double width = 0;
    double height = 0;
    if(currentContext != null){
      DeviceView view = DeviceManager().getDeviceView(currentContext);
      switch(size){
        case ObjectSize.big:
          width = view == DeviceView.expanded ? 70 : 60;
          break;
        case ObjectSize.normal:
          width = view == DeviceView.expanded ? 60 : 50;
          break;
        case ObjectSize.small:
          width = view == DeviceView.expanded ? 50 : 40;
          break;
      }
    }
    if(width != 0){
      height = (3*width)/4;
    }
    return Size(width,height);
  }
}