import 'package:dags_user/Features/SignIn/view/widgets/SignInWidgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/widgets/app_button_widgets.dart';
import '../../../Common/widgets/app_text_fields.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../Controller/signincontroller.dart';
import '../Provider/signinnotifier.dart';

class SignINScreen extends ConsumerStatefulWidget {
  const SignINScreen({super.key});

  @override
  ConsumerState<SignINScreen> createState() => _SignINScreenState();
}

class _SignINScreenState extends ConsumerState<SignINScreen> {
  late DeliveryPartnerController02 _controller;
  bool isLoading = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _controller = DeliveryPartnerController02();
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
                body: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(horizontal: 10.h),
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
                              signInText(),
                              signInText02(),
                              SizedBox(
                                height: 30.h,
                              ),
                              textLoginBoxWithDimensions(
                                  height: 45.h,
                                  width: 325.w,
                                  hintText: "Phone No.",
                                  controller: _controller.phoneNoController,
                                  keyboardType: TextInputType.number,
                                  func: (value) => ref
                                      .read(SignInNotifierProvider.notifier)
                                      .onUserPhoneNoChange(value)),
                              SizedBox(height: 300.h),
                              Container(
                                  margin:
                                      EdgeInsets.only(left: 29.w, right: 25.w),
                                  child: appButtons(
                                      buttonText: "Next",
                                      buttonColor: AppColors.primaryElement,
                                      buttonTextColor: AppColors.primaryText,
                                      buttonBorderWidth: 2.h,
                                      anyWayDoor: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _controller.handleSignIn(ref);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      })),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    textcustomnormal(
                                      text:
                                          "By clicking on Next you are agreeing to our",
                                      align: TextAlign.center,
                                      fontSize: 14,
                                      fontfamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navKey.currentState
                                            ?.pushNamed('/terms_scr');
                                      },
                                      child: textcustomnormal(
                                        text: "Terms and conditions.",
                                        align: TextAlign.center,
                                        fontSize: 14,
                                        fontfamily: "Inter",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              registerText03(),
                            ],
                          ),
                        ),
                      ))));
  }
}
