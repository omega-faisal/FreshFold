import 'package:dags_user/Common/Services/global.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  static String url = AppConstants.serverApiUrl;

  Future<void> fetchUser() async {
    try {
      final phoneNumber =
          Global.storageServices.getString(AppConstants.userPhoneNumber);
      var response = await http.post(Uri.parse("$url/client/api/fetchProfile"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'phone': phoneNumber}));
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("user fetched successfully");
        }
        var jsonResponse = jsonDecode(response.body);
        var userResponse = User.fromJson(jsonResponse['user']);
        state = userResponse;
      } else if (response.statusCode == 500) {
        if (kDebugMode) {
          print("could not fetch profile");
        }
      } else {
        if (kDebugMode) {
          print("bad response -> ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error occurred while fetching user -> $e');
      }
    }
  }
}
