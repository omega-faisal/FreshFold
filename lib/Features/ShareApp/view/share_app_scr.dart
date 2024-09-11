import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/image_res.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Share App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          dashLine(
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Center(
            child: Image.asset(
              ImageRes.shareappimage,
              height: 350.h,
            ),
          ),
          const Center(
            child: Text(
              'Send Invitation',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Inter"),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Help your family,friends and colleagues by sharing the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Center(
            child: appButtons(
                buttonText: "Copy Link",
                buttonBorderWidth: 1.5.h,
                buttonTextColor: AppColors.primaryElement,
                borderColor: Colors.grey.shade400,
                height: 50.h,
                width: 340.w,
                anyWayDoor: () async {
                  await Clipboard.setData(ClipboardData(
                      text:
                          "https://play.google.com/store/apps/details?id=com.dags.laundry"));
                  await Share.share(
                      'Hey I am using Dags laundry for effortless laundry services. Download the app now https://play.google.com/store/apps/details?id=com.dags.laundry');
                  Fluttertoast.showToast(
                      msg: "App link has been copied to the clipboard.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColors.primaryElement,
                      textColor: Colors.black,
                      fontSize: 16.0);
                },
                buttonColor: const Color(0xfffffaee)),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
