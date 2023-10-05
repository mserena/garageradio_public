import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/defines/theme.dart';
import 'package:garageradio/services/language_manager.dart';
import 'package:garageradio/services/settings/app_settings.dart';
import 'package:garageradio/services/settings/settings_manager.dart';

class NotificationManager{
  final List<CustomNotificationType> _notifications = [];
  Flushbar? _currentNotification;

  // Singleton
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager(){
    return _instance;
  }

  NotificationManager._internal();

  init() async{

  }

  void addNotification(CustomNotificationType type){
    if(!_notifications.contains(type)){
      CustomNotification? newNotification = SettingsManager().appSettings.notifications.firstWhereOrNull((notification) => notification.type == type);
      if(newNotification != null){
        _notifications.add(type);
        _showNextNotification();
      }
    }
  }

  Future<void> cleanNotifications({CustomNotificationType? type}) async{
    if(_notifications.isNotEmpty){
      if(type == null){
        _notifications.clear();
        if(_currentNotification != null){
          await _currentNotification!.dismiss();
        }
      } else {
        CustomNotificationType currentNotificationType = _notifications.first;
        if(_currentNotification != null && currentNotificationType == type){
          await _currentNotification!.dismiss();
        } else {
          _notifications.removeWhere((notificationType) => notificationType == type);
        }
      }
    }
  }

  void _showNextNotification(){
    if(_notifications.isNotEmpty && !isShowingNotification()){
      _show(_notifications.first);
    }
  }

  void _show(CustomNotificationType type){
    if(gNavigatorStateKey.currentContext != null){
      CustomNotification? newNotification = SettingsManager().appSettings.notifications.firstWhereOrNull((notification) => notification.type == type);
      if(newNotification != null){
        _currentNotification = Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.transparent,
          margin: const EdgeInsets.fromLTRB(20, defTopBarHeigth, 20, 0),
          padding: const EdgeInsets.all(0),
          duration: newNotification.time == 0 ? null : const Duration(seconds: 3),
          isDismissible: false,
          animationDuration: const Duration(milliseconds: 500),
          flushbarStyle: FlushbarStyle.FLOATING,
          onTap: (flushBar) async {
            if(newNotification.time != 0){
              flushBar.dismiss();
            }
          },
          onStatusChanged: (status) {
            if(status != null){
              switch(status) {
                case FlushbarStatus.SHOWING:
                case FlushbarStatus.IS_APPEARING:
                case FlushbarStatus.IS_HIDING:
                  {
                    break;
                  }
                case FlushbarStatus.DISMISSED:
                  {
                    _currentNotification = null;
                    if(_notifications.isNotEmpty){
                      _notifications.removeAt(0);
                    }
                    _showNextNotification();
                    break;
                  }
              }
            }
          },
          messageText: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    defBackgroundNotificationColorBegin,
                    defBackgroundNotificationColorEnd
                  ]
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                LanguageManager().getText(newNotification.text),
                style: Theme.of(gNavigatorStateKey.currentContext!).textTheme.titleMedium!,
                textAlign: TextAlign.center,
              )
            ),
          ),
        );
        _currentNotification!.show(gNavigatorStateKey.currentContext!);
      }
    }
  }

  bool isShowingNotification(){
    return _currentNotification != null;
  }
}