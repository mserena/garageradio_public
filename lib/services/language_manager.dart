import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/services/local_storage_manager.dart';

class LanguageManager{
  Map<String, dynamic> _texts = <String,dynamic>{};
  String _currentLanguage = gDefaultLanguage;

  // Singleton
  static final LanguageManager _instance = LanguageManager._internal();

  factory LanguageManager(){
    return _instance;
  }

  LanguageManager._internal();

  init() async{
    String language = await _getPlatformLanguageOrDefault();
    await setCurrentLanguage(language); 
  }

  Future<String> _getPlatformLanguageOrDefault() async {
    String language = gDefaultLanguage;
    String? prefLanguage = LocalStorageManager().storage.getString(gPreferenceLanguage);
    if(prefLanguage != null){
      language = prefLanguage;
    } else {
      try {
        String? platformLanguage = await Devicelocale.currentLocale;
        if(platformLanguage != null){
          platformLanguage = platformLanguage.substring(0, platformLanguage.indexOf('-'));
          if(gDefaultLanguagesList.firstWhereOrNull((lang) => lang['isoCode'] == platformLanguage) != null){
            language = platformLanguage;
            debugPrint('current device language $language supported.');
          }
        }
      }catch(e){
        debugPrint("Exception obtaining current device language: ${e.toString()}");
      }
    }
    return language;
  }

  Future<bool> _loadLanguageFile(String path) async{
    try{
      String jsonString = await rootBundle.loadString(path);
      Map<String,dynamic> jsonTexts = json.decode(jsonString);
      _texts = jsonTexts;
      return true;
    }catch(e){
      debugPrint('error on loadLanguageFile: ${e.toString()}');
    }
    return false;
  }

  Future<bool> setCurrentLanguage(String newLanguage) async {
    if(_texts.isEmpty || newLanguage != _currentLanguage){
      if(gDefaultLanguagesList.firstWhereOrNull((lang) => lang['isoCode'] == newLanguage) != null){
        if(await _loadLanguageFile(_getLanguagePath(newLanguage))){
          _currentLanguage = newLanguage;
          LocalStorageManager().storage.setString(gPreferenceLanguage, _currentLanguage);
          return true;
        }
      }
    }
    return false;
  }

  String _getLanguagePath(String code){
    return 'assets/languages/$code.json';
  }

  String getCurrentLanguage(){
    return _currentLanguage;
  }

  String getText(String id){ 
    if(_texts.containsKey(id)){
      return _texts[id];
    } else {
      debugPrint('Text without translation: $id');
      return id;
    }
  }
}