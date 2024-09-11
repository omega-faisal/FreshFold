import 'package:dags_user/Features/TimeSlotScreen/provider/time_slot_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Common/utils/constants.dart';

final timeSlotProvider = StateNotifierProvider<TimeSlotNotifier, List<TimeSlotModel>?>((ref) {
  return TimeSlotNotifier();
});

class TimeSlotNotifier extends StateNotifier<List<TimeSlotModel>?> {
  TimeSlotNotifier() : super([]) {
    fetchTimeSlotData();
  }

  Future<void> fetchTimeSlotData() async {

    final String url = AppConstants.serverApiUrl;
    final response = await http.get(Uri.parse('$url/client/api/timeSlot'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<TimeSlotModel> items = (data['timeSlots'] as List)
          .map((item) => TimeSlotModel.fromJson(item))
          .toList();
      state = items;
    } else {
      throw Exception('Failed to load time slot data');
    }
  }
}
