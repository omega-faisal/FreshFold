class Order {
  final String id;
  final String orderId;
  final DateTime orderDate;
  final List<OrderStatus> orderStatus;
  final double amount;
  final double? discount;
  final double deliveryFee;
  final double vendorFee;
  final double taxes;
  final String? paymentMode;
  final String transactionId;
  final String? paymentId;
  final String? paymentSignature;
  final String userId;
  final String vendorId;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String? razorpayKey;
  final String? secretKey;
  final String? orderLocation;
  final List<Item> items;
  final List<String> orderPics;
  final String? notes;
  double? feedbackRating;
  final dynamic deliveryType;
  final double finalAmount ;
  final double platformFee;

  Order(
      {required this.id,
      required this.deliveryType,
      required this.orderId,
      required this.orderDate,
      required this.orderStatus,
      required this.amount,
        required this.discount,
      required this.deliveryFee,
      required this.vendorFee,
      required this.taxes,
      this.paymentMode,
      required this.transactionId,
      this.paymentId,
      this.paymentSignature,
      required this.userId,
      required this.vendorId,
      this.pickupDate,
      this.deliveryDate,
      this.razorpayKey,
      this.secretKey,
      this.orderLocation,
      required this.items,
      required this.orderPics,
      this.notes,
      required this.feedbackRating,
      required this.finalAmount,
      required this.platformFee});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['_id'] ?? '',
        orderId: json['orderId'] ?? '',
        orderDate: DateTime.parse(
            json['orderDate'] ?? DateTime.now().toIso8601String()),
        orderStatus: (json['orderStatus'] as List<dynamic>?)
                ?.map((x) => OrderStatus.fromJson(x))
                .toList() ??
            [],
        amount: json['amount']?.toDouble() ?? 0.0,
        discount: double.parse(json['discount'].toString()),
        deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
        vendorFee: json['vendorFee']?.toDouble() ?? 0.0,
        taxes: json['taxes']?.toDouble() ?? 0.0,
        paymentMode: json['paymentMode'],
        transactionId: json['transactionId'] ?? '',
        paymentId: json['paymentId'],
        paymentSignature: json['paymentSignature'],
        userId: json['userId'] ?? '',
        vendorId: json['vendorId'] ?? '',
        deliveryType: json['deliveryType'],
        pickupDate: json['pickupDate'] != null
            ? DateTime.parse(json['pickupDate'])
            : null,
        deliveryDate: json['deliveryDate'] != null
            ? DateTime.parse(json['deliveryDate'])
            : null,
        razorpayKey: json['razorpayKey'],
        secretKey: json['secretKey'],
        orderLocation: json['orderLocation'],
        items: (json['items'] as List<dynamic>?)
                ?.map((x) => Item.fromJson(x))
                .toList() ??
            [],
        orderPics: (json['order_pics'] as List<dynamic>?)
                ?.map((x) => x as String)
                .toList() ??
            [],
        notes: json['notes'],
        platformFee: double.parse(json['platformFee'].toString()),
        finalAmount: double.parse(json['finalAmount'].toString()),
        feedbackRating: double.parse(json['feedbackRating'] ?? '0'));
  }
}

class OrderStatus {
  final String id;
  final String status;
  final DateTime? time;

  OrderStatus({
    required this.id,
    required this.status,
    this.time,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
    );
  }
}

class Item {
  final String id;
  final String itemId;
  final String serviceId;
  final String? itemName;
  final String? serviceName;
  final double unitPrice;
  final int qty;

  Item({
    required this.id,
    required this.itemId,
    required this.serviceId,
    this.itemName,
    this.serviceName,
    required this.unitPrice,
    required this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] ?? '',
      itemId: json['itemId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      itemName: json['itemNAME'] ?? 'item name',
      serviceName: json['serviceNAME'] ?? 'item service',
      unitPrice: json['unitPrice']?.toDouble() ?? 0.0,
      qty: json['qty'] ?? 0,
    );
  }
}

class OrdersResponse {
  final List<Order> activeOrders;
  final List<Order> pastOrders;

  OrdersResponse({
    required this.activeOrders,
    required this.pastOrders,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      activeOrders: (json['activeOrders'] as List<dynamic>?)
              ?.map((x) => Order.fromJson(x))
              .toList() ??
          [],
      pastOrders: (json['pastOrders'] as List<dynamic>?)
              ?.map((x) => Order.fromJson(x))
              .toList() ??
          [],
    );
  }
}
