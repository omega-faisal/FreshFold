import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/widgets/text_widgets.dart';
import '../../Provider/order_radio_notifier.dart';

Widget radioSwipeableButton(
    {void Function()? selectRadio01,
      void Function()? selectRadio02,
      required WidgetRef ref}) {
  bool active = ref.watch(orderRadioNotifierProvider);
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: selectRadio01!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(40.w, 0, 0, 0),
              child: const textcustomnormal(
                text: "Active Orders",
                fontSize: 16,
                fontfamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              width: 195.w,
              height: 2.h,
              color: active ? const Color(0xff1C254E) : Colors.grey.shade400,
            )
          ],
        ),
      ),
      GestureDetector(
        onTap: selectRadio02!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(60.w, 0, 0, 0),
              child: const textcustomnormal(
                text: "Past Order",
                fontSize: 16,
                fontfamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              width: 195.w,
              height: 2.h,
              color: active ? Colors.grey.shade400 : const Color(0xff1C254E),
            )
          ],
        ),
      )
    ],
  );
}