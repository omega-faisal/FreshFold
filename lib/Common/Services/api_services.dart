import 'dart:convert';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/utils/nearestVendorModel.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../Features/AccountsScreen/provider/user_model.dart';
import '../utils/app_colors.dart';
import 'global.dart';
import 'misc_models.dart';

class API {
  static String Token = "Token";
  static String url = AppConstants.serverApiUrl;

  static Future<Map<String, dynamic>> registerUser(
      String phoneNumber, String name) async {
    Map<String, dynamic> data = {'phone': phoneNumber, 'name': name};
    try {
      var response = await http.post(
        Uri.parse("$url/client/api/signup"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      }
      if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Account already exists!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Check your internet connection!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return {
        'error': 'Failed to register user. Status code: ${response.statusCode}'
      };
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return {'error': 'Exception caught: $e'};
    }
  }

  static Future<Map<String, dynamic>> loginUser(String phoneNumber) async {
    Map<String, dynamic> data = {'phone': phoneNumber};
    try {
      if (kDebugMode) {
        print(url);
      }
      var response = await http.post(
        Uri.parse("$url/client/api/login"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(data),
      );
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "Account does not exist!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Check your internet connection",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (response.statusCode == 995) {
        Fluttertoast.showToast(
            msg: "Too many attempts\nTry again later!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Could not login at this time.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("error in login -> ${response.statusCode}");
        }
      }
      return {
        'error': 'Failed to register user. Status code: ${response.statusCode}'
      };
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return {'error': 'Exception caught: $e'};
    }
  }

  static Future<Map<String, dynamic>> enterOtp(
      String phoneNumber, String otp) async {
    Map<String, dynamic> data = {'phone': phoneNumber, 'otp': otp};
    try {
      var response = await http.post(
        Uri.parse("$url/client/api/verifyOTP"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print(jsonResponse);
        }
        return jsonResponse;
      }
      if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Incorrect otp, try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Otp could not be fetched, kindly try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return {
        'error': 'Failed to fetch otp. Status code: ${response.statusCode}'
      };
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return {'error': 'Exception caught: $e'};
    }
  }

  static Future<bool> addAddressFromNewAddress(
      String address, String pinCode, String phoneNumber) async {
    try {
      final uri = Uri.parse("$url/client/api/addAddress");

      var response = await http.put(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(
              {'phone': phoneNumber, 'address': address, 'pincode': pinCode}));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Address added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("Address added successfully");
        }
        return true;
      }
      if (response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "User not found, try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Check your internet connection",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<bool> updateProfile(String email, String name,
      {String? profilePic = null}) async {
    try {
      final phoneNumber =
          Global.storageServices.getString(AppConstants.userPhoneNumber);

      Map<String, String?> data = {
        'phone': phoneNumber,
        'name': name,
        'email': email
      };

      if (profilePic != null) {
        data['profilePic'] = profilePic;
      }
      final uri = Uri.parse("$url/client/api/updateUser");

      var response = await http.put(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Profile updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("profile updated successfully");
        }
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Profile could not be updated\ntry again later!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<bool> addAddressFromLocation(
      {required String phoneNumber,
      required String lat,
      required String longi}) async {
    try {
      final uri = Uri.parse("$url/client/api/addAddress");
      var response = await http.put(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(
              {'phone': phoneNumber, 'latitude': lat, 'longitude': longi}));
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        return true;
      }
      if (response.statusCode == 404) {
        if (kDebugMode) {
          print("user is not there");
        }
        Fluttertoast.showToast(
            msg: "User not found, try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Address could not be fetched due to bad connection.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<Charges> fetchCharges() async {
    try {
      final response = await http.get(Uri.parse('$url/admin/api/fetchMisc'));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("fetch charges has been successfully  hit");
        }
        if (kDebugMode) {
          print(Charges.fromJson(jsonDecode(response.body)['charges']).tax);
        }
        return Charges.fromJson(jsonDecode(response.body)['charges']);
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else {
        throw Exception(
            'Failed to load charges with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load charges: $e');
    }
  }

  static Future<Map<dynamic, dynamic>> sendFeedback(
      String orderId, String feedback, double rating) async {
    Map<String, dynamic> data = {
      'orderId': orderId,
      'feedback': feedback,
      'rating': rating
    };
    try {
      var response = await http.post(
        Uri.parse("$url/client/api/review"),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("review sent");
        }
        if (kDebugMode) {}
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else {
        throw Exception(
            'Failed to load charges with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load charges: $e');
    }
  }

  static Future<bool> updateAddress(
      String address, String phoneNumber, int index) async {
    try {
      final uri = Uri.parse("$url/client/api/updateaddress");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(
              {'phone': phoneNumber, 'address': address, 'index': index}));
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        Fluttertoast.showToast(
            msg: "Address updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("Address updated successfully");
        }
        return true;
      }
      if (response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "User not found, try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      if (response.statusCode == 502) {
        Fluttertoast.showToast(
            msg: "Address could not be updated due to bad connection.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<NearestVendorModel?> findNearestVendor(
      String phoneNumber) async {
    try {
      final uri = Uri.parse("$url/client/api/findNearestVendor");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'phone': phoneNumber}));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("inside good block");
        }
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final result = NearestVendorModel.fromJson(jsonResponse);
        if (kDebugMode) {
          print("nearest vendor found");
        }
        return result;
      } else {
        Fluttertoast.showToast(
            msg: "No vendors available in your area",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return null;
    }
  }

  static Future<bool> createNewOrder(
      {required Map<String, dynamic> data}) async {
    try {
      final uri = Uri.parse("$url/client/api/createOrder");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(data));
      final checkResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print(checkResponse);
      }
      if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final serviceMessage = jsonResponse['message'];
        if (kDebugMode) {
          print("service message is -> $serviceMessage");
        }
        OrderModel.razorpayOrderId = jsonResponse['razorpayOrder']['id'];
        OrderModel.orderId = jsonResponse['order']['orderId'];
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Could not create order at this time!\nTry again later.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
    return false;
  }

  static Future<bool> cancelOrder({required String orderId}) async {
    try {
      if (kDebugMode) {
        print(orderId);
      }
      final uri = Uri.parse("$url/client/api/cancel");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'orderId': orderId}));

      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("message is -> $jsonResponse['message']");
        }
        Fluttertoast.showToast(
            msg: "Order is cancelled.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Order Could not be cancelled, please try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
    return false;
  }

  static Future<bool> cancelRefundOrder({required String orderId}) async {
    try {
      if (kDebugMode) {
        print(orderId);
      }
      final uri = Uri.parse("$url/client/api/cancel");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'orderId': orderId, 'refundRequest': true}));

      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("message is -> $jsonResponse['message']");
        }
        Fluttertoast.showToast(
            msg:
                "Order is cancelled.\nThe amount will be refunded within 7-business days",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Order Could not be cancelled, please try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
    }
    return false;
  }

  static Future<bool> verifyPayment(
      {required String paymentId,
      required String orderId,
      required String razorpayOrderId,
      required String paymentSignature}) async {
    try {
      final uri = Uri.parse("$url/client/api/verifyPayment");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({
            "orderId": orderId,
            "paymentId": paymentId,
            "paymentSignature": paymentSignature,
            "razorpayOrderId": razorpayOrderId,
          }));
      final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print('verify payment response is -> $jsonResponse');
      }
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Your order is confirmed!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("payment verified.");
        }
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Payment could not be verified, please try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred in  -> ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<bool> findLogisticPartner({
    required String orderId,
    required String vendorId,
  }) async {
    try {
      final uri = Uri.parse("$url/client/api/ShortestDistanceforUser");
      var response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({
            "orderId": orderId,
            "vendorId": vendorId,
          }));
      final jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print(jsonResponse);
      }
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Pickup agent is assigned.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("partner found.");
        }
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "No pickup agents found.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryElement,
            textColor: Colors.black,
            fontSize: 16.0);
        if (kDebugMode) {
          print("some error occurred -> ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught: $e');
      }
      return false;
    }
  }

  static Future<User?> fetchUser() async {
    try {
      final phoneNumber =
          Global.storageServices.getString(AppConstants.userPhoneNumber);
      var response = await http.post(Uri.parse("$url/client/api/fetchProfile"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'phone': phoneNumber}));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("user fetched successfully");
        }
        var jsonResponse = jsonDecode(response.body);
        var userResponse = User.fromJson(jsonResponse['user']);
        return userResponse;
      } else if (response.statusCode == 500) {
        if (kDebugMode) {
          print("could not fetch profile");
        }
        return null;
      } else {
        if (kDebugMode) {
          print("bad response -> ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('error occurred while fetching user -> $e');
      }
      return null;
    }
  }

  static Future<bool> checkServiceAvailability() async {
    try {
      final phoneNumber =
          Global.storageServices.getString(AppConstants.userPhoneNumber);
      var response = await http.post(
          Uri.parse("$url/client/api/serviceAvailable"),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'phone': phoneNumber}));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['logisticAvailable'] && jsonResponse['vendorAvailable'];
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
