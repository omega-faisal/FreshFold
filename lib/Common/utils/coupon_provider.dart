import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'coupon_model.dart';

class CouponsNotifier extends StateNotifier<List<Coupon>> {
  CouponsNotifier() : super([]);

  Future<void> fetchCoupons() async {
    final url = AppConstants.serverApiUrl;
    try {
      final response = await http.get(Uri.parse('$url/client/api/coupon'));

      debugPrint('${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final couponsJson = data['coupons'] as List;
        final List<Coupon> coupons = couponsJson.map((json) => Coupon.fromJson(json)).toList();

        state = coupons;
      } else {
        throw Exception('Failed to load coupons');
      }
    } catch (e) {
      // Handle the error
      debugPrint('$e');
    }
  }
}
final couponsProvider = StateNotifierProvider<CouponsNotifier, List<Coupon>>((ref) {
  return CouponsNotifier();
});
