import 'package:garageradio/defines/globals.dart';
import 'package:garageradio/utils/notification_utils.dart';

class CustomNotification{
  final CustomNotificationType type;
  final int time;
  final String text;

  CustomNotification({required this.type, required this.time, required this.text});

  factory CustomNotification.fromJson(Map<String, dynamic> data) {
    final CustomNotificationType type = NotificationUtils.getCustomNotificationTypeFromString(data['type'] as String);
    final int time = data['time'] as int;
    final String text = data['text'] as String;
    return CustomNotification(type: type, time: time, text: text);
  }
}

class AppSettings{
  List<String> loadingPhrases;
  String radioServerDefault;
  List<CustomNotification> notifications;

  AppSettings({
    required this.loadingPhrases,
    required this.radioServerDefault,
    required this.notifications
  });

  factory AppSettings.fromJson(Map<String, dynamic> data) {
    List<dynamic> loadingPhrases = data['loadingPhrases'] as List<dynamic>;
    loadingPhrases.shuffle();
    String radioServerDefault = data['radioServerDefault'];
    final List<dynamic> notificationsData = data['notifications'] as List<dynamic>;
    final List<CustomNotification> notifications = notificationsData.map((notificationData) => CustomNotification.fromJson(notificationData)).toList();
    return AppSettings(
      loadingPhrases: List<String>.from(loadingPhrases),
      radioServerDefault: radioServerDefault,
      notifications: notifications
    );
  }
}