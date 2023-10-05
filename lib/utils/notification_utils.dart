import 'package:garageradio/defines/globals.dart';

class NotificationUtils{

  static CustomNotificationType getCustomNotificationTypeFromString(String notificationTypeStr) {
    for (CustomNotificationType type in CustomNotificationType.values) {
      String currentTypeStr = type.toString().split('.').last;
      if (currentTypeStr == notificationTypeStr) {
          return type;
      }
    }
    return CustomNotificationType.unknown;
  }
  
}
