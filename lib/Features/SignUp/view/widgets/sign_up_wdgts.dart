import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/widgets/text_widgets.dart';
import '../../../../main.dart';

Widget deliveryPartnerText() {
  return textcustomnormal(
    text: "Sign Up",
    fontWeight: FontWeight.w500,
    fontSize: 36.w,
    color: const Color(0xff161416),
  );
}

Widget deliveryPartnerText02() {
  return text16normal(
    color: Colors.grey.shade500,
    text: "By creating a free account",
    fontWeight: FontWeight.w400,
  );
}

Widget registerText03() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const text16normal(
        text: "Already a member?",
        fontWeight: FontWeight.w400,
      ),
      SizedBox(
        width: 4.w,
      ),
      GestureDetector(
        onTap: () {
          navKey.currentState
              ?.pushNamedAndRemoveUntil("/sign_in_scr", (route) => false);
        },
        child: const text16normal(
          text: "Sign In",
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
