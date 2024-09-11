import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Common/Services/global.dart';
import 'notification_model.dart';

class NotificationsNotifier extends StateNotifier<List<AppNotification>?> {
  NotificationsNotifier() : super([]);

  Future<void> fetchNotifications() async {
    final url = 'https://dagstechnology.in/client/api/notifications';
    final phoneNumber =
        Global.storageServices.getString(AppConstants.userPhoneNumber);
    try {
      final response =
          await http.post(Uri.parse(url), body: {'phone': phoneNumber});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final notificationsJson = data['notifications'] as List;
        final List<AppNotification> notifications = notificationsJson
            .map((json) => AppNotification.fromJson(json))
            .toList();

        state = notifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print(e);
    }
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>?>((ref) {
  return NotificationsNotifier();
});
