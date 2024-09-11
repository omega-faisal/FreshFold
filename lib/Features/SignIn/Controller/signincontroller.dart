import 'package:dags_user/Common/utils/app_colors.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Features/SignIn/Provider/signinnotifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Common/Services/api_services.dart';
import '../../../Common/Services/global.dart';
import '../../../main.dart';

class DeliveryPartnerController02 {
  TextEditingController phoneNoController = TextEditingController();

  Future<void> handleSignIn(WidgetRef ref) async {
    var state = ref.watch(SignInNotifierProvider);
    String phoneNo = state.phoneNo;
    if (phoneNo.isEmpty ||
        phoneNoController.text.isEmpty ||
        phoneNo.length != 10) {
      await Fluttertoast.showToast(
          msg: "Please enter valid phone number.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      var response = await API.loginUser(phoneNo);
      if (response.containsKey('success') && response['success'] == true) {
        // storing the phone no entered by the user
        Global.storageServices.setString(AppConstants.userPhoneNumber, phoneNo);
        await Fluttertoast.showToast(
            msg: "An OTP has been send to $phoneNo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        navKey.currentState
            ?.pushNamed("/otp_scr", arguments: {'fromLogin': true});
      } else {
        if (kDebugMode) {
          print("some error occurred while getting you signed in");
        }
      }
    }
  }
}
