import 'package:dags_user/Common/Services/global.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Features/AddressDetails/Provider/AddressDetailNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Common/Services/api_services.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../main.dart';

class AddAddressController {
  bool isOnlyWhitespace(String input) {
    return input.trim().isEmpty;
  }

  Future<void> handleAddAddress(WidgetRef ref) async {
    var state = ref.watch(addressDetailNotifierProvider);
    var addressLine01 = state.address01;
    var addressLine02 = state.address02;
    var postalCode = state.postalCode;
    addressLine01 = addressLine01.replaceAll(',', '-');
    addressLine02 = addressLine02.replaceAll(',', '-');
    postalCode = postalCode.replaceAll(',', '');
    postalCode = postalCode.trim();
    final phoneNumber =
        Global.storageServices.getString(AppConstants.userPhoneNumber);

    if (addressLine01.isEmpty && addressLine02.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter your address.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    } else if (postalCode.isEmpty || postalCode.contains('.') || postalCode.contains(',')) {
      Fluttertoast.showToast(
          msg: "Please enter postal code of your area correctly.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    else if(isOnlyWhitespace(addressLine01) || isOnlyWhitespace(addressLine02))
      {
        Fluttertoast.showToast(
            msg: "Please enter valid address.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      else {
      final newAddress = "$addressLine01, $addressLine02, $postalCode";
      bool isSuccess = await API.addAddressFromNewAddress(
          newAddress, postalCode, phoneNumber);
      if (isSuccess) {
        navKey.currentState?.pop();
      }
    }
  }
}
