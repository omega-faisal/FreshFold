class AddressDetailState {
  final String address01;
  final String address02;
  final String city;
  final String province;
  final String postalCode;

  ///CONSTRUCTOR
  const AddressDetailState(
      {this.address01 = "",
      this.address02 = "",
      this.city = "",
      this.province = "",
      this.postalCode = ""});

  ///Methode
  AddressDetailState copyWith(
      {String? address01,
      String? city,
      String? address02,
      String? province,
      String? postalCode}) {
    return AddressDetailState(
      address01: address01 ?? this.address01,
      address02: address02 ?? this.address02,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
