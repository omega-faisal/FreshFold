import 'package:dags_user/Common/utils/image_res.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderConfirmScreen extends StatelessWidget {
  const OrderConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageRes.orderconfirmimage,
              height: 430,
            ),
            const Text(
              'Your order is confirmed',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Inter"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Text(
                "We are delighted to have you and assure you that we are committed to providing you with the best possible service.",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins"),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            appButtons(
                buttonText: "View Order Details",
                anyWayDoor: () {
                  navKey.currentState?.pushNamedAndRemoveUntil(
                      "/order_info_scr", (route) => false, arguments: {
                    'orderId': OrderModel.orderId,
                    'active': true
                  });
                },
                buttonBorderWidth: 2.h,
                buttonTextColor: Colors.black,
                width: 340.w,
                height: 50.h)
          ],
        ),
      ),
    );
  }
}
