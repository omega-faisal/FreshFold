import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'DeliveryPrtState.dart';

class DeliveryPrtNotifier extends StateNotifier<DeliveryPrtState>
{
  // Constructor
  DeliveryPrtNotifier():super(const DeliveryPrtState());

  void onUserNameChange(String name)
  {
    state=state.copyWith(userName: name);
  }
  void onUserPhoneNoChange(String phoneNo)
  {
    state=state.copyWith(phoneNo: phoneNo);
  }
}

final deliveryPrtNotifierProvider= StateNotifierProvider<DeliveryPrtNotifier,DeliveryPrtState>((ref) {
  return DeliveryPrtNotifier();
});
