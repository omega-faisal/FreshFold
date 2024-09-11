import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'AddressDetailsState.dart';


class AddressDetailNotifier extends StateNotifier<AddressDetailState>
{
  // Constructor
  AddressDetailNotifier():super(const AddressDetailState());

  void onAddressLine01Change(String address01)
  {
    state=state.copyWith(address01: address01);
  }
  void onAddressLine02Change(String address02)
  {
    state=state.copyWith(address02: address02);
  }
  void onCityChange(String city)
  {
    state=state.copyWith(city: city);
  }
  void onProvinceChange(String province)
  {
    state=state.copyWith(province: province);
  }
  void onCodeChange(String code)
  {
    state=state.copyWith(postalCode: code);
  }
}

final addressDetailNotifierProvider= StateNotifierProvider<AddressDetailNotifier,AddressDetailState>((ref) {
  return AddressDetailNotifier();
});
