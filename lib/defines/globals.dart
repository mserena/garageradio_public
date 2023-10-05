import 'package:flutter/material.dart';

//Global Variables
final GlobalKey<NavigatorState> gNavigatorStateKey = GlobalKey<NavigatorState>();
const String gAudioPlayerId = "radioAudioPlayer";

// Values
const int gMaxRadioStations = 150;
const int gVolumeSteps = 4;

//Device 
enum DeviceView{
  compact,
  expanded
}

enum DeviceType{
  web,
  mobile
}

enum ObjectSize{
  big,
  normal,
  small
}

enum TopBarPosition{
  left,
  center,
  right
}

//Notifications
enum CustomNotificationType{
  // Connection
  connectionError,
  //General error
  unknownError,
  //Not implemented notification
  unknown,
}

//Element UI Ids
const String gTopBarLoadingElementId = 'loading';

//Preferences Ids
const String gPreferenceLanguage = 'pLanguage';

//Languages
const String gDefaultLanguage = 'en';
const List gDefaultLanguagesList = [
  {"isoCode": "es", "name": "Spanish", "flag": "es"},
  {"isoCode": "en", "name": "English", "flag": "gb"},
];
