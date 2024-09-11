import 'package:dags_user/Features/SignUp/view/widgets/sign_up_wdgts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/widgets/app_button_widgets.dart';
import '../../../Common/widgets/app_text_fields.dart';
import '../Controller/DeliveryPartnerController.dart';
import '../Provider/delivery_prt_notifier.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late DeliveryPartnerController _controller;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _controller = DeliveryPartnerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
        designSize: Size(ScreenWidth, ScreenHeight),
        builder: (context, child) => SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Image.asset(
                          ImageRes.logo,
                          height: 40.h,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        deliveryPartnerText(),
                        deliveryPartnerText02(),
                        SizedBox(
                          height: 30.h,
                        ),
                        textLoginBoxWithDimensions(
                            height: 45.h,
                            width: 325.w,
                            hintText: "Full Name",
                            controller: _controller.nameController,
                            func: (value) {
                              ref
                                  .read(deliveryPrtNotifierProvider.notifier)
                                  .onUserNameChange(value);
                            }),
                        SizedBox(
                          height: 15.h,
                        ),
                        textLoginBoxWithDimensions(
                            height: 45.h,
                            width: 325.w,
                            hintText: "Phone No.",
                            keyboardType: TextInputType.number,
                            controller: _controller.phoneNoController,
                            func: (value) {
                              ref
                                  .read(deliveryPrtNotifierProvider.notifier)
                                  .onUserPhoneNoChange(value);
                            }),
                        SizedBox(
                          height: 300.h,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 29.w, right: 25.w),
                            child: appButtons(
                                buttonText: "Next",
                                buttonColor: AppColors.primaryElement,
                                buttonTextColor: AppColors.primaryText,
                                buttonBorderWidth: 2.h,
                                anyWayDoor: () {
                                  _controller.handleSignUp(ref);
                                })),
                        SizedBox(
                          height: 5.h,
                        ),
                        registerText03()
                      ],
                    ),
                  ),
                ))));
  }
}
