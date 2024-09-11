class AppNotification {
  final String id;
  final String notificationId;
  final String title;
  final String? subtitle;
  final String notificationFor;
  final DateTime orderDate;
  final DateTime createdAt;
  final String? orderId;

  AppNotification({
    required this.id,
    required this.notificationId,
    required this.title,
    this.subtitle,
    required this.notificationFor,
    required this.orderDate,
    required this.createdAt,
    this.orderId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      notificationId: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      notificationFor: json['notificationFor'],
      orderDate: DateTime.parse(json['orderDate']),
      createdAt: DateTime.parse(json['createdAt']),
      orderId: json['orderId'],
    );
  }
}
