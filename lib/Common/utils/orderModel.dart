class OrderModel {
  static String note = "not provided";
  static String deliveryType = "";
  static DateTime date = DateTime.now();
  static String image = "";
  static int itemTotal = 0;
  static String vendorId = "";
  static int deliveryFee = 0;
  static String? razorpayOrderId = "";
  static String? paymentId = "";
  static String? paymentSignature = "";
  static double totalAmount = 0;
  static String orderAddress = "";
  static String? orderId = "";
  static String isAppOpen = "";
  static String profilePic = "";
}

class OrderForApiBody {
  String itemId;
  int qty;
  String serviceId;
  int unitPrice;

  OrderForApiBody(
      {required this.itemId,
      required this.qty,
      required this.serviceId,
      required this.unitPrice});

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'qty': qty,
      'serviceId': serviceId,
      'unitPrice': unitPrice
    };
  }
}
