class DeliveryPrtState {
  final String userName;
  final String phoneNo;

  ///CONSTRUCTOR
  const DeliveryPrtState(
      {this.userName = "",
        this.phoneNo = ""});

  ///Methode
  DeliveryPrtState copyWith(
      {String? userName,
        String? email,
        String? phoneNo}) {
    return DeliveryPrtState(
        userName: userName ?? this.userName,
        phoneNo: phoneNo ?? this.phoneNo);
  }
}
