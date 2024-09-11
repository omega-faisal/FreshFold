class FetchAddressResponse {
  final List<dynamic> address;


  FetchAddressResponse({required this.address});

  factory FetchAddressResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> result = json['address'];
    return FetchAddressResponse(
      address: result,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}
