import 'dart:convert';

import 'package:dags_user/Features/HomeScreen/Provider/home_service_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../Common/utils/constants.dart';

final servicesProvider =
    StateNotifierProvider<ServiceNotifier, List<Service>>((ref) {
  return ServiceNotifier();
});

class ServiceNotifier extends StateNotifier<List<Service>> {
  ServiceNotifier() : super([]);

  static String url = AppConstants.serverApiUrl;

  Future<void> fetchServices() async {
    try {
      var response = await http.get(
        Uri.parse("$url/client/api/fetchServices"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var serviceResponse = ServiceResponse.fromJson(jsonResponse);
        if (kDebugMode) {
          print(serviceResponse.message);
        }
        if (jsonDecode(response.body).containsKey('minOrderAmount')) {
          AppConstants.minOrderAmount =
              jsonDecode(response.body)['minOrderAmount'];
        }
        state = serviceResponse.service;
      } else if (response.statusCode == 500) {
        if (kDebugMode) {
          print("could not find services");
        }
      } else {
        if (kDebugMode) {
          print("bad response -> ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error occurred while fetching services -> $e');
      }
    }
  }
}

final itemProvider = StateNotifierProvider<ItemNotifier, List<Item>>((ref) {
  return ItemNotifier();
});

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super([]);

  static String url = AppConstants.serverApiUrl;
  List<Item> items = [];

  Future<void> fetchItems() async {
    try {
      var response = await http.get(
        Uri.parse("$url/client/api/fetchServices"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('successfully opened item request');
        }
        var serviceResponse = ServiceResponse.fromJson(jsonResponse);

        for (var service in serviceResponse.service) {
          if (kDebugMode) {
            print(service.id);
          }
          service.items.expand((item) {
            return [item]; // Convert each item to a list with one element
          }).forEach((item) {
            items.add(item);
          });
        }
        state = items;
      } else {
        if (kDebugMode) {
          print("bad response -> ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error occurred while fetching items -> $e');
      }
    }
  }
}
