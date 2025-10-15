import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  bool _notificationsEnabled = false;
  bool _isLoading = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notificationsEnabled = await NotificationService.requestPermission();
    } catch (e) {
      print('Error initializing notifications: $e');
      _notificationsEnabled = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> requestPermission() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notificationsEnabled = await NotificationService.requestPermission();
    } catch (e) {
      print('Error requesting notification permission: $e');
      _notificationsEnabled = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await NotificationService.cancelAllNotifications();
    } catch (e) {
      print('Error canceling notifications: $e');
    }
  }
}


