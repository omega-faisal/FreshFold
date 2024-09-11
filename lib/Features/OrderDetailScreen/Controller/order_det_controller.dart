import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/utils/nearestVendorModel.dart';
import 'package:flutter/foundation.dart';

import '../../../Common/Services/api_services.dart';
import '../../../Common/Services/global.dart';

class OrderDetController {
  Future<NearestVendorModel?> findNearestVendor() async {
    final phoneNumber =
        Global.storageServices.getString(AppConstants.userPhoneNumber);
    final response = await API.findNearestVendor(phoneNumber);
    if (response != null) {
      // final shortestDist = response.shortestDistance ?? 0;
      // final closestVendor = response.closestVendor ?? 0;
      final deliveryFee = response.deliveryFee ?? 0;
      final vendorId = response.vendorID??0;
      if (kDebugMode) {
        print(
            "shortest dist is ->delivery fee is -> $deliveryFee,vendor id is-> $vendorId");
      }
      return response;
    }
    else
      {
        if (kDebugMode) {
          print("response is null");
        }
        return null;
      }
  }
  Future<bool> handleCreateOrder(Map<String, dynamic> data) async{
    final isSuccess = await API.createNewOrder(data: data);
    if(isSuccess)
      {
        if (kDebugMode) {
          print("everything is okay");
        }
        return true;
      }
    else
      {
        if (kDebugMode) {
          print("error occurred while creating order");
        }
        return false;
      }
 }
}
