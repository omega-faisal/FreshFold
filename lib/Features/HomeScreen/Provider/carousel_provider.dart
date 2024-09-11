import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'carousel_model.dart';

final carouselProvider = StateNotifierProvider<CarouselNotifier, List<CarouselItem>?>((ref) {
  return CarouselNotifier();
});

class CarouselNotifier extends StateNotifier<List<CarouselItem>?> {
  CarouselNotifier() : super([]) {
    fetchCarouselData();
  }

  Future<void> fetchCarouselData() async {
    final String url = AppConstants.serverApiUrl;
    final response = await http.get(Uri.parse('$url/client/api/carousel'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<CarouselItem> items = (data['carousel'] as List)
          .map((item) => CarouselItem.fromJson(item))
          .toList();
      state = items;
    } else {
      throw Exception('Failed to load carousel data');
    }
  }
}
