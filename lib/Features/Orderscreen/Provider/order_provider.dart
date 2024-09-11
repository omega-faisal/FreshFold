import 'dart:convert';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../Common/Services/global.dart';
import 'order_model.dart';

class OrderNotifier extends StateNotifier<OrdersResponse> {
  final String apiUrl = AppConstants.serverApiUrl;

  OrderNotifier() : super(OrdersResponse(activeOrders: [], pastOrders: []));

  Future<void> loadOrders() async {
    try {
      final phoneNumber =
          Global.storageServices.getString(AppConstants.userPhoneNumber);
      final Uri uri = Uri.parse('$apiUrl/client/api/fetchAllOrders');
      final response = await http.post(uri,
          body: jsonEncode({'phone': phoneNumber}),
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      if (response.statusCode == 200) {
        debugPrint('response is ${response.body}');

        final orders = OrdersResponse.fromJson(json.decode(response.body));
        if (!mounted) return;
        state = orders;
      } else {
        debugPrint('${response.statusCode}');
        throw Exception('Failed to load orders, ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print("Orders could not be fetched due to $e");
      }
      state = OrdersResponse(
          activeOrders: [], pastOrders: []); // Reset state on error
    }
  }
}

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, OrdersResponse>((ref) {
  return OrderNotifier();
});
