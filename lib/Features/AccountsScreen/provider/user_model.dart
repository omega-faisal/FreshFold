class User {
  String? id;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? profilePic;
  String? otp;
  List<String>? address;
  List<String>? orders;
  List<String>? ip;
  DateTime? lastLogin;

  User({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.profilePic,
    this.otp,
    this.address,
    this.orders,
    this.ip,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePic: json['profilePic'],
      otp: json['OTP'],
      address:
          json['address'] != null ? List<String>.from(json['address']) : [],
      orders: json['orders'] != null ? List<String>.from(json['orders']) : [],
      ip: json['ip'] != null ? List<String>.from(json['ip']) : [],
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

}
