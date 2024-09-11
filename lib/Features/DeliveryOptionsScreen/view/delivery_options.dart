import 'package:dags_user/Common/utils/app_colors.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class DeliveryOptions extends ConsumerStatefulWidget {
  const DeliveryOptions({super.key});

  @override
  ConsumerState<DeliveryOptions> createState() => _DeliveryOptionsState();
}

class _DeliveryOptionsState extends ConsumerState<DeliveryOptions> {
  bool isExpressSelected = false;
  bool isFirstIconPressed = false;
  bool isSecondIconPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: const Text(
                      'Delivery Type',
                      style: TextStyle(
                          color: Color(0xff1C254E),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter"),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  dashLine(
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const Text(
                      'Choose your preferred delivery option:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  isExpressSelected
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                padding: EdgeInsets.all(10.w),
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.h),
                                    topRight: Radius.circular(10.h),
                                    bottomLeft: isFirstIconPressed
                                        ? Radius.circular(0.h)
                                        : Radius.circular(10.h),
                                    bottomRight: isFirstIconPressed
                                        ? Radius.circular(0.h)
                                        : Radius.circular(10.h),
                                  ),
                                  border: Border.all(color: Colors.black),
                                  color: Colors.yellow.shade700,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Express Delivery',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Inter",
                                        color: Color(0xff1C254E),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isFirstIconPressed =
                                                    !isFirstIconPressed;
                                              });
                                            },
                                            child: Icon(Icons.info_outline,
                                                size: 25.h,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                          size: 27.h,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isFirstIconPressed
                                  ? Container(
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.h),
                                            bottomRight: Radius.circular(10.h),
                                          ),
                                          border:
                                              Border.all(color: Colors.black)),
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const textcustomnormal(
                                                text:
                                                    "1. Takes less than 24 hrs.",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontfamily: "Inter",
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              const textcustomnormal(
                                                text:
                                                    "2. Extra Charges Applied.",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontfamily: "Inter",
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpressSelected = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.h),
                                topRight: Radius.circular(10.h),
                                bottomLeft: Radius.circular(10.h),
                                bottomRight: Radius.circular(10.h),
                              ),
                              border: Border.all(color: Colors.black),
                              color: AppColors.documentButtonBg,
                            ),
                            margin: EdgeInsets.only(
                                left: 20.w, top: 15.h, right: 20.w),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Express Delivery',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                    color: Color(0xff1C254E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: 10.h),
                  !isExpressSelected
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                padding: EdgeInsets.all(10.w),
                                height: 55.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.h),
                                    topRight: Radius.circular(10.h),
                                    bottomLeft: isSecondIconPressed
                                        ? Radius.circular(0.h)
                                        : Radius.circular(10.h),
                                    bottomRight: isSecondIconPressed
                                        ? Radius.circular(0.h)
                                        : Radius.circular(10.h),
                                  ),
                                  border: Border.all(color: Colors.black),
                                  color: Colors.yellow.shade700,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Normal Delivery',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Inter",
                                        color: Color(0xff1C254E),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isSecondIconPressed =
                                                    !isSecondIconPressed;
                                              });
                                            },
                                            child: Icon(Icons.info_outline,
                                                size: 25.h,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Icon(
                                          Icons.check_outlined,
                                          color: Colors.green,
                                          size: 27.h,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isSecondIconPressed
                                  ? Container(
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.h),
                                            bottomRight: Radius.circular(10.h),
                                          ),
                                          border:
                                              Border.all(color: Colors.black)),
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const textcustomnormal(
                                                text: "1. Takes 2-3 days",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontfamily: "Inter",
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              const textcustomnormal(
                                                text:
                                                "2. Normal delivery charges applied.",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontfamily: "Inter",
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpressSelected = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.h),
                                topRight: Radius.circular(10.h),
                                bottomLeft: Radius.circular(10.h),
                                bottomRight: Radius.circular(10.h),
                              ),
                              border: Border.all(color: Colors.black),
                              color: AppColors.documentButtonBg,
                            ),
                            margin: EdgeInsets.only(
                                left: 20.w, top: 15.h, right: 20.w),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Normal Delivery',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                    color: Color(0xff1C254E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Spacer(),
            Center(
                child: appButtons(
                    height: 50.h,
                    width: 340.w,
                    buttonText: "Proceed",
                    buttonTextColor: Colors.black,
                    buttonBorderWidth: 1.5.h,
                    anyWayDoor: () {
                      if (isExpressSelected) {
                        OrderModel.deliveryType = "express";
                        navKey.currentState
                            ?.pushNamed("/address_for_order_scr");
                      } else if (!isExpressSelected) {
                        OrderModel.deliveryType = "normal";
                        navKey.currentState?.pushNamed("/time_slot_scr");
                      }
                    }))
          ],
        ),
      ),
    );
  }
}

//color: isExpressSelected ? Colors.yellow.shade700 : Colors.white,


