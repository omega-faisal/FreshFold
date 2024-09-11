import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Common/utils/app_colors.dart';

class InstructionScreen extends ConsumerStatefulWidget {
  const InstructionScreen({super.key});

  @override
  ConsumerState<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends ConsumerState<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: buildAppBar(context: context),
        body: Padding(
          padding: EdgeInsets.only(left:16.h,right:16.h,bottom: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    const Text(
                      'Add Laundry Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      'Let us know if you have specific things in mind',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'e.g. Take extra good care of tuxedo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                      controller: controller,
                      maxLines: 6,
                    ),

                  ],
                ),
              ),
              Spacer(),
              Center(
                child: appButtons(
                    height: 50.h,
                    width: 340.w,
                    anyWayDoor: () {
                      navKey.currentState?.pushNamed("/del_op_scr");
                    },
                    buttonText: "Skip",
                    buttonColor: const Color(0xffFFFAEE),
                    buttonTextColor: Colors.black,
                    buttonBorderWidth: 1.5.h,
                    borderColor: AppColors.primaryElement),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: appButtons(
                    height: 50.h,
                    width: 340.w,
                    anyWayDoor: () {
                      if (controller.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg:
                            "Please type instructions to continue\nor you can skip.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.primaryElement,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      } else {
                        if (kDebugMode) {
                          print(controller.text);
                        }
                        OrderModel.note = controller.text;
                        navKey.currentState?.pushNamed("/del_op_scr");
                      }
                    },
                    buttonText: "Submit",
                    buttonColor: AppColors.primaryElement,
                    buttonTextColor: Colors.black,
                    buttonBorderWidth: 1.5.h,
                    borderColor: Colors.black),
              )
            ],
          ),
        ));
  }
}
