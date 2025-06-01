import 'package:autoexplorer/repositories/notifications/model/notification.dart';

abstract class NotificationsRepositoryI {
  Future<void> init();
  Future<String?> getToken();
  Future<bool> requestPermisison();
  Future<void> showLocalNotification(Notification notification);
}