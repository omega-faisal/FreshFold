class NearestVendorModel {
  dynamic shortestDistance;
  Vendor? closestVendor; // Updated type to Vendor
  dynamic deliveryFee;
  String? vendorID;

  // Constructor
  NearestVendorModel({
    this.shortestDistance,
    this.closestVendor,
    required this.vendorID,
    required this.deliveryFee,
  });

  // Factory method to create an instance from JSON
  factory NearestVendorModel.fromJson(Map<String, dynamic> json) {
    return NearestVendorModel(
      shortestDistance: json['shortestDistance'],
      closestVendor: json['closestvendor'] != null
          ? Vendor.fromJson(json['closestvendor'])
          : null,
      deliveryFee: json['deliveryFee'],
      vendorID: json['closestvendor'] != null ? json['closestvendor']['vendorId'] as String? : null, // Extract vendorId
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shortestDistance'] = shortestDistance;
    if (closestVendor != null) {
      data['closestvendor'] = closestVendor!.toJson(); // Convert Vendor to JSON
    }
    data['deliveryFee'] = deliveryFee;
    data['vendorID'] = vendorID;
    return data;
  }
}

// Vendor class to handle vendor details
class Vendor {
  String id;
  String name;
  String address;
  String vendorId;

  Vendor({
    required this.id,
    required this.name,
    required this.address,
    required this.vendorId,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      vendorId: json['vendorId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['vendorId'] = vendorId;
    return data;
  }
}
