import 'dart:convert';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../Common/utils/app_colors.dart';
import 'fetch_address_model.dart';

class AddressNotifier extends StateNotifier<FetchAddressResponse?> {
  AddressNotifier() : super(null);

  Future<void> fetchAddress(String phoneNumber) async {
    const String url = AppConstants.serverApiUrl;
    try {
      final uri = Uri.parse("$url/client/api/fetchAddress");
      if (kDebugMode) {
        print(phoneNumber);
      }
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'phone': phoneNumber}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final addressResponse = FetchAddressResponse.fromJson(jsonResponse);
        state = addressResponse;
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "User not found, try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        if (kDebugMode) {
          print("user not found");
        }
      } else if (response.statusCode == 502) {
        Fluttertoast.showToast(
          msg: "Address could not be fetched\nCheck your internet connection.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        if (kDebugMode) {
          print("bad connection");
        }
      } else {
        if (kDebugMode) {
          print("error occurred");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, FetchAddressResponse?>((ref) {
  return AddressNotifier();
});
