import 'package:dags_user/Common/Services/api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/constants.dart';
import '../../../main.dart';
import '../Provider/delivery_prt_notifier.dart';

class DeliveryPartnerController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  Future<void> handleSignUp(WidgetRef ref) async {
    var state = ref.watch(deliveryPrtNotifierProvider);
    nameController.text = state.userName;
    phoneNoController.text = state.phoneNo;
    String userName = state.userName;
    String phoneNo = state.phoneNo;

    if (phoneNo.isEmpty || userName.isEmpty || phoneNo.length != 10) {
      Fluttertoast.showToast(
          msg: "Please provide required details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      var response = await API.registerUser(phoneNo, userName);
      if (response.containsKey('success') && response['success'] == true) {
        // storing the phone no  and username entered by the user
        Global.storageServices.setString(AppConstants.userPhoneNumber, phoneNo);
        Global.storageServices.setString(AppConstants.userName, userName);
        Global.storageServices.setBool(AppConstants.nameSet, true);
        if (kDebugMode) {
          print('Registration successful');
        }
        await Fluttertoast.showToast(
            msg: "An OTP has been sent to your phone number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        navKey.currentState
            ?.pushNamed("/otp_scr", arguments: {"fromLogin": false});
      } else {
        if (kDebugMode) {
          print("Registration is unsuccessful.");
        }
      }
    }
  }
}
