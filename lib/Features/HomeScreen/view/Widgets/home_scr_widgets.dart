import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/widgets/app_shadow.dart';
import '../../../../Common/widgets/text_widgets.dart';

Widget orderRow(String cardTask, String imagePath) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.w),
    child: Card(
        shadowColor: Colors.grey.shade400,
        elevation: 2.0,
        // clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: appBoxDecoration(
              color: const Color(0xff1d254e),
              radius: 10,
              borderWidth: 0,
              borderColor: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.network(
                imagePath,
                color: Colors.white70,
                height: 50.h,
                width: 50.h,
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: textcustomnormal(
                    text: cardTask,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontfamily: "Poppins",
                    color: Color.fromARGB(210, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}

Widget optionRow02(String optionType, String imagePath) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.h),
    alignment: Alignment.center,
    child: Card(
        shadowColor: Colors.grey.shade400,
        elevation: 10.0,
        clipBehavior: Clip.hardEdge,
        child: Container(
          alignment: Alignment.center,
          width: 150.w,
          height: 140.h,
          decoration: appBoxDecoration(
              color: Color.fromARGB(255, 245, 202, 62),
              radius: 10,
              borderWidth: 0,
              borderColor: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                  child: Image.network(
                imagePath,
                height: 60.h,
                width: 60.h,
                fit: BoxFit.cover,
              )),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: textcustomnormal(
                    text: optionType,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontfamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}

//  Widget promoCodeContainer(String imagePath) {
//   return Container(
//     height: 120.h,
//     width: 250.w,
//     decoration: appBoxDecoration(
//         radius: 20.w, borderWidth: 0.0, borderColor: Colors.white),
//     child: Stack(
//       children: [
//         Image.asset(
//           imagePath,
//           fit: BoxFit.fill,
//         ),
//         Container(
//           padding: EdgeInsets.fromLTRB(10.w, 45.h, 80.w, 0.h),
//           height: 120.h,
//           width: 250.w,
//           decoration: appBoxDecoration(
//               radius: 20.w,
//               borderWidth: 0.0,
//               color: Colors.black.withOpacity(0.1)),
//           child: Image.asset(ImageRes.promocode),
//         )
//       ],
//     ),
//   );
// }
