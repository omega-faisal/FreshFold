import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Common/utils/image_res.dart';
import '../../../../Common/widgets/text_widgets.dart';

Widget appOnboardingPage(PageController controller,
    {required String imagePath,
    required String title,
    required String subtitle,
    required BuildContext context,
    int index = 0}) {
  return Column(children: [
    Image.asset(
      ImageRes.logo,
      height: 40.h,
    ),
    SizedBox(
      height: 10.h,
    ),
    Image.asset(
      imagePath,
      height: 350.h,
    ),
     SizedBox(
      height: 30.h,
    ),
    textcustomnormal(
      align: TextAlign.center,
      fontfamily: "Inter",
      fontWeight: FontWeight.w700,
      fontSize: 26,
      text: title,
    ),
     SizedBox(
      height: 5.h,
    ),
    Padding(
      padding:  EdgeInsets.only(left: 30.w, right: 30.w),
      child: textcustomnormal(
        color: Colors.grey.shade500,
        text: subtitle,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontfamily: "Inter",
      ),
    ),
  ]);
}
