import 'package:dags_user/Common/Services/api_services.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'Common/Services/global.dart';
import 'Common/utils/app_colors.dart';

class RazorpayScreen extends StatefulWidget {
  const RazorpayScreen({super.key});

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  late Razorpay _razorpay;
  bool isLoading = false;
  bool isCancelLoading = false;
  bool isPaymentCompleted = false;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      isPaymentCompleted = true;
    });
    Future.delayed(const Duration(seconds: 1), () async {
      Fluttertoast.showToast(
          msg: "Payment completed successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.primaryElement,
          textColor: Colors.black,
          fontSize: 16.0);
      OrderModel.paymentId = response.paymentId ?? "empty";
      OrderModel.razorpayOrderId = response.orderId ?? "0";
      OrderModel.paymentSignature = response.signature ?? "empty again";
      await API.verifyPayment(
          orderId: OrderModel.orderId!,
          paymentId: OrderModel.paymentId!,
          paymentSignature: OrderModel.paymentSignature!,
          razorpayOrderId: OrderModel.razorpayOrderId!);

      bool isSuccess = await API.findLogisticPartner(
          orderId: OrderModel.orderId!, vendorId: OrderModel.vendorId);
      if (isSuccess) {
        navKey.currentState
            ?.pushNamedAndRemoveUntil("/order_confirm_scr", (route) => false);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment unsuccessful.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryElement,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "External Wallet",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: AppColors.primaryElement,
    //     textColor: Colors.black,
    //     fontSize: 16.0);
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void openSession(num amount) {
    final userContact =
        Global.storageServices.getString(AppConstants.userPhoneNumber);
    var options = {
      'key': AppConstants.razorPayKey,
      'amount': amount * 100,
      'name': 'Dags Technology Pvt. Ltd.',
      'order_id': OrderModel.razorpayOrderId,
      'description': 'Description for order',
      'timeout': 300,
      'prefill': {
        'contact': userContact,
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error in Razorpay: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  handlePopUpForRazorpay(BuildContext context) async {
    bool dialog = false;
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you really want to go back?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () async {
                bool realSuccess = await cancelOrder();
                if (realSuccess) {
                  dialog = true;
                }
                Navigator.pop(context, true);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Inter",
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                dialog = false;
                Navigator.pop(context, true);
                // Navigator.pop(context, false);
              },
              child: const Text('No',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter",
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
    return dialog;
  }

  Future<bool> cancelOrder() async {
    if (kDebugMode) {
      print('order id is -> ${OrderModel.orderId}');
    }
    OrderModel.itemTotal = 0;
    bool isSuccess = await API.cancelOrder(orderId: OrderModel.orderId!);
    return isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool x = await handlePopUpForRazorpay(context);
        if (x) {
          navKey.currentState?.pushNamedAndRemoveUntil(
              "/order_info_scr", (route) => false,
              arguments: {'orderId': OrderModel.orderId, 'active': false});
        }
        return false;
      },
      child: Scaffold(
        appBar: buildAppBarWithoutActionAndLeading(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const textcustomnormal(
                    text: "Amount to Pay",
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    fontfamily: "Inter",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  textcustomnormal(
                    text: '₹ ${OrderModel.totalAmount}',
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontfamily: "Inter",
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  isPaymentCompleted
                      ? const Center(child: CircularProgressIndicator())
                      : appButtons(
                          height: 50.h,
                          width: 340.w,
                          buttonText: "Proceed To Pay",
                          buttonTextColor: Colors.black,
                          anyWayDoor: () {
                            setState(() {
                              isLoading = true;
                            });
                            final total = OrderModel.totalAmount;
                            openSession(total);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          buttonBorderWidth: 1.5.h),
                ],
              )),
      ),
    );
  }
}
