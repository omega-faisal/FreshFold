import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Common/Services/api_services.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';


class AddressDetailController {
  TextEditingController address01Controller = TextEditingController();
  TextEditingController address02Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  bool isOnlyWhitespace(String input) {
    return input.trim().isEmpty;
  }

  Future<void> updateAddressController(WidgetRef ref,int index) async {
    var address01 = address01Controller.text;
    var address02 = address02Controller.text;
    var postalCode = postalCodeController.text;
    address01 = address01.replaceAll(',', '');
    address02 = address02.replaceAll(',', '');
    postalCode = postalCode.replaceAll(',', '');
    postalCode = postalCode.trim();
    if (address01.isEmpty || address02.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Your Address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    else if (postalCode.isEmpty || postalCode.contains('.') || postalCode.contains(',')) {
      Fluttertoast.showToast(
          msg: "Please enter postal code of your area correctly",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    else if(isOnlyWhitespace(address01) || isOnlyWhitespace(address02))
    {
      Fluttertoast.showToast(
          msg: "Please Enter Valid Address.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    else{
      var address = "$address01, $address02, $postalCode";
      final phoneNumber = Global.storageServices.getString(AppConstants.userPhoneNumber);
      bool isSuccess = await API.updateAddress(address, phoneNumber, index);
      if(isSuccess)
      {
        navKey.currentState?.pop();
      }
    }
  }
}
