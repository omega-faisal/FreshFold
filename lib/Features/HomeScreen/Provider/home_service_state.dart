import 'package:dags_user/Common/utils/image_res.dart';
import 'package:flutter/foundation.dart';

class ServiceManager {
  // Singleton instance
  static final ServiceManager _instance = ServiceManager._internal();

  // Factory constructor
  factory ServiceManager() {
    return _instance;
  }

  // Private constructor
  ServiceManager._internal();

  // Map to hold services and items
  final Map<String, Map<String, dynamic>> _services = {};

  // Method to initialize the services from the API response
  void setServiceWithIdAndItems(Service service) {
    _services[service.id!] = {
      'serviceName': service.serviceName,
      'vendorCommission': service.vendorCommission,
      'items': service.items.map((item) => item).toList(),
      'serviceId': service.serviceId,
    };
  }

  // Method to get service by ID
  Map<String, dynamic>? getServiceById(String serviceId) {
    return _services[serviceId];
  }

  // Method to get item by service ID and item ID
  Item? getItem(String serviceId, String itemId) {
    var service = _services[serviceId];
    if (service != null) {
      var items = service['items'] as List<Item>;
      return items.firstWhere((item) => item.id == itemId);
    }
    return null;
  }

  // Method to increment item quantity
  void incrementItemQuantity(String serviceId, String itemId) {
    var service = _services[serviceId];
    if (service != null) {
      var items = service['items'] as List<Item>;
      var item = items.firstWhere((item) => item.id == itemId);
      item.quantity += 1;
      if (kDebugMode) {
        print("working well --> ${item.quantity}");
      }
    }
  }

  // Method to decrement item quantity
  void decrementItemQuantity(String serviceId, String itemId) {
    var service = _services[serviceId];
    if (service != null) {
      var items = service['items'] as List<Item>;
      var item = items.firstWhere(
        (item) => item.id == itemId,
      );
      if (kDebugMode) {
        print("working well --> ${item.quantity}");
      }
      if (item.quantity > 0) {
        item.quantity -= 1;
      }
    }
  }

  // Method to get all services
  Map<String, Map<String, dynamic>> getAllServicesWithIdAndItems() {
    return _services;
  }
}

class ServiceResponse {
  final String? message;
  final List<Service> service;

  ServiceResponse({
    required this.message,
    required this.service,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    var serviceList = json['service'] as List;
    List<Service> services =
        serviceList.map((i) => Service.fromJson(i)).toList();

    return ServiceResponse(
      message: json['message'] ?? "",
      service: services,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'service': service.map((s) => s.toJson()).toList(),
    };
  }
}

class Service {
  final String? id;
  final String? serviceName;
  final int? vendorCommission;
  final List<Item> items;
  final String? serviceId;
  final String? serviceIcon;

  Service(
      {required this.id,
      required this.serviceName,
      required this.vendorCommission,
      required this.items,
      required this.serviceId,
      required this.serviceIcon});

  factory Service.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Item> items = itemsList.map((i) => Item.fromJson(i)).toList();

    return Service(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? "test service",
      vendorCommission: json['vendorCommission'] ?? 0,
      items: items,
      serviceId: json['serviceId'] ?? '',
      serviceIcon:json['serviceIcon']??ImageRes.noImageFound
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceName': serviceName,
      'vendorCommission': vendorCommission,
      'items': items.map((i) => i.toJson()).toList(),
      'serviceId': serviceId,
    };
  }
}

class Item {
  final String? name;
  final int? unitPrice;
  final String? id;
  final String? itemId;
  final String? itemIcon;

  int quantity;

  Item({
    this.quantity = 0,
    required this.name,
    required this.unitPrice,
    required this.id,
    required this.itemId,
    required this.itemIcon,

  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? "",
      unitPrice: json['unitPrice'] ?? 0,
      id: json['_id'] ?? '',
      itemId: json['itemId'] ?? '',
      itemIcon: json['itemIcon']??'',
      quantity: 0, // Initialize quantity to 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unitPrice': unitPrice,
      '_id': id,
      'itemId': itemId,
      'quantity': quantity, // Include quantity in toJson
    };
  }
}
