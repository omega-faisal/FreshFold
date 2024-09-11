class Coupon {
  final String id;
  final String couponName;
  final int couponDiscount;
  final int minAmount;
  final int maxDiscount;
  final String description;
  final int usedTimes;
  final DateTime expiryAt;
  final bool status;
  final bool isFlat;
  final DateTime createdAt;

  Coupon({
    required this.id,
    required this.couponName,
    required this.couponDiscount,
    required this.minAmount,
    required this.maxDiscount,
    required this.description,
    required this.usedTimes,
    required this.expiryAt,
    required this.status,
    required this.isFlat,
    required this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['_id'],
      couponName: json['couponName'],
      couponDiscount: json['couponDiscount'],
      minAmount: json['minAmount'],
      maxDiscount: json['maxDiscount'],
      description: json['description'],
      usedTimes: json['usedTimes'],
      expiryAt: DateTime.parse(json['expiryAt']),
      status: json['status'],
      isFlat: json['isFlat'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
