import 'package:flutter/material.dart';
import 'package:garageradio/services/language_manager.dart';
import 'package:garageradio/services/local_storage_manager.dart';
import 'package:garageradio/services/package_info_manager.dart';
import 'package:garageradio/services/radio/radio_manager.dart';
import 'package:garageradio/services/settings/settings_manager.dart';

class ServicesLoader{
  bool _servicesLoaded = false;
  bool _loadingServices = false;

  // Singleton
  static final ServicesLoader _instance = ServicesLoader._internal();

  factory ServicesLoader(){
    return _instance;
  }

  ServicesLoader._internal();

  Future<void> loadServices({useFirebaseEmulator = false}) async{
    if(!_servicesLoaded && !_loadingServices){
      _loadingServices = true;
      debugPrint('Services loader start.');
      
      try{
        await LocalStorageManager().init(clear: false);
      }catch(e){
        debugPrint('Error loading services LocalStorageManager: ${e.toString()}');
      }

      try{
        await PackageInfoManager().init();
      }catch(e){
        debugPrint('Error loading services PackageInfoManager: ${e.toString()}');
      }

      try{
        await LanguageManager().init();
      }catch(e){
        debugPrint('Error loading services LanguageManager: ${e.toString()}');
      }

      try{
        await SettingsManager().init();
      }catch(e){
        debugPrint('Error loading services SettingsManager: ${e.toString()}');
      }

      try{
        await RadioManager().init();
      }catch(e){
        debugPrint('Error loading services RadioManager: ${e.toString()}');
      }
      
      try{
        // This is just for see loading page animation, in a real app the priority is to load all fast, for sure.
        await Future.delayed(const Duration(seconds: 2));
      }catch(e){
        debugPrint('Error loading services Wait: ${e.toString()}');
      }

      debugPrint('Services loader finished.');
      _servicesLoaded = true;
      _loadingServices = false;
    }
  }

  bool isServicesLoaded(){
    return _servicesLoaded;
  }
}