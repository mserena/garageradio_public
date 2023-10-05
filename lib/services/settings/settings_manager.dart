import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garageradio/services/settings/app_settings.dart';

class SettingsManager{
  final ValueNotifier<bool> _initialized = ValueNotifier(false);
  late AppSettings appSettings;

  // Singleton
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager(){
    return _instance;
  }

  SettingsManager._internal();

  init() async{
    try{
      String jsonStringAppSettings = await rootBundle.loadString('assets/settings/app_settings.json');
      Map<String, dynamic> jsonObjectAppSettings = jsonDecode(jsonStringAppSettings); 
      appSettings = AppSettings.fromJson(jsonObjectAppSettings);
      _initialized.value = true;
    }catch(ex){
      debugPrint('Exception when loading app settings json: ${ex.toString()}');
    }
  }

  ValueNotifier<bool> isInitialized(){
    return _initialized;
  }
}