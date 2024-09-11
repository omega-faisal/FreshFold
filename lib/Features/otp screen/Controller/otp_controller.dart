import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Features/otp%20screen/Provider/otp_notifier.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/Services/api_services.dart';
import '../../../Common/Services/global.dart';
import '../../../main.dart';

class OtpController {
  Future<bool> handleOtp(WidgetRef ref) async {
    var state = ref.watch(otpNotifierProvider);
    var otp = state.otp;
    var phoneNo = Global.storageServices.getString(AppConstants.userPhoneNumber);
    if (kDebugMode) {
      print(phoneNo);
    }

    var response = await API.enterOtp(phoneNo, otp);
    if (response.containsKey('success') && response['success'] == true) {
      // Storing the token...0
      Global.storageServices.setString(AppConstants.storageUserTokenKey, response['token']);
      if (kDebugMode) {
        print(Global.storageServices.getString(AppConstants.storageUserTokenKey));
      }
      Global.storageServices.setBool(AppConstants.userRegisteredEarlier, true);
      if (kDebugMode) {
        print('got otp successful');
      }
      navKey.currentState
          ?.pushNamedAndRemoveUntil("/location_scr", (route) => false);
      return true;
    } else {
      return false;
    }
  }
}
