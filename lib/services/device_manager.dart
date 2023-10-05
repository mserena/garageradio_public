import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';

class DeviceManager{
  // Singleton
  static final DeviceManager _instance = DeviceManager._internal();

  factory DeviceManager(){
    return _instance;
  }

  DeviceManager._internal();

  DeviceView getDeviceView(BuildContext context){ 
    if (getDeviceType() == DeviceType.web) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      if (width > defMinExpandedViewWidth && height > defMinExpandedViewHeigth) {
        return DeviceView.expanded;
      }
    }
    
    // running on mobile
    return DeviceView.compact;
  }

  DeviceType getDeviceType(){
    return kIsWeb ? DeviceType.web : DeviceType.mobile;
  }
}