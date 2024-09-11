import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/main.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../providers/welcome_index_provider.dart';
import 'Widgets/widgets.dart';

class Welcome extends ConsumerStatefulWidget {
  Welcome({super.key});

  @override
  ConsumerState<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome> {
  final PageController _controller = PageController();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    final index = ref.watch(welcome_indProvider);
    return ScreenUtilInit(
      designSize: Size(ScreenWidth, Screenheight),
      builder: (context, child) => Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(top: 50.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                    onPageChanged: (value) {
                      ref.read(welcome_indProvider.notifier).changeIndex(value);
                    },
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    children: [
                      appOnboardingPage(_controller,
                          imagePath: ImageRes.swipe01image,
                          title:
                              "Welcome to DAGS",
                          subtitle:
                          "Effortless laundry service at your fingertips",
                          index: 1,
                          context: context),
                      appOnboardingPage(_controller,
                          imagePath: ImageRes.swipe02image,
                          title: "Convenient Scheduling",
                          subtitle:
                          "Book a pickup and delivery time that fits your schedule.",
                          index: 2,
                          context: context),
                      appOnboardingPage(_controller,
                          imagePath: ImageRes.swipe03image,
                          title: "Quality Care",
                          subtitle:
                          "Your clothes handled with the utmost care and precision.",
                          index: 3,
                          context: context)
                    ]),
                Positioned(
                  bottom: 120.h,
                  child: DotsIndicator(
                    position: index,
                    dotsCount: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    decorator: DotsDecorator(
                        activeColor: Colors.grey.shade600,
                        size: Size.square(9.0.h),
                        activeSize: Size(24.0.w, 8.0.h),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Global.storageServices.setBool(AppConstants.openedFirstTime, false);
                            navKey.currentState?.pushNamedAndRemoveUntil(
                                "/sign_up_scr", (route) => false);
                          },
                          child: const textcustomnormal(
                            text: "Skip",
                            color: Colors.black,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (index < 2) {
                              _controller.animateToPage(index + 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                            } else {
                              Global.storageServices.setBool(AppConstants.openedFirstTime, false);
                              navKey.currentState?.pushNamedAndRemoveUntil(
                                  "/sign_up_scr", (route) => false);
                            }
                          },
                          child: const textcustomnormal(
                            text: "Next ->",
                            color: Colors.black,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
