import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/widgets/app_bar.dart';
import '../../../Common/widgets/app_button_widgets.dart';
import '../../../Common/widgets/app_shadow.dart';
import '../../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBarWithoutActionAndLeading(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  documentsButtons(
                      buttonText: "My Addresses",
                      buttonIcon: Icons.location_on,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/address_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Help & Support",
                      buttonIcon: Icons.help,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/help_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Share App",
                      buttonIcon: Icons.share,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/share_app_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "About Us",
                      buttonIcon: Icons.book_outlined,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/about_us_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Terms & Conditions",
                      buttonIcon: Icons.newspaper_outlined,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/terms_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Shipping Policy",
                      buttonIcon: Icons.rule_sharp,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/shipping_policy_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Refund Policy",
                      buttonIcon: Icons.policy_outlined,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/refund_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Privacy Policies",
                      buttonIcon: Icons.policy,
                      anyWayDoor: () {
                        navKey.currentState?.pushNamed("/privacy_scr");
                      }),
                  SizedBox(
                    height: 15.h,
                  ),
                  documentsButtons(
                      buttonText: "Sign Out",
                      buttonIcon: Icons.logout,
                      anyWayDoor: () {
                        Global.storageServices
                            .setBool(AppConstants.userRegisteredEarlier, false);
                        Global.storageServices
                            .setBool(AppConstants.nameSet, false);
                        Global.storageServices
                            .setBool(AppConstants.locationGranted, false);
                        Global.storageServices
                            .setBool(AppConstants.openedFirstTime, true);
                        navKey.currentState?.pushNamedAndRemoveUntil(
                            "/sign_in_scr", (route) => false);
                      }),
                  SizedBox(
                    height: 20.h,
                  ),
                  textcustomnormal(
                    text: 'App version : 1.0.0',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontfamily: "Inter",
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      navKey.currentState?.pushNamedAndRemoveUntil(
                          "/application_scr", (route) => false);
                    },
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        alignment: Alignment.center,
                        decoration: appBoxDecoration(
                            radius: 20.h,
                            color: AppColors.documentButtonBg,
                            borderColor: AppColors.primaryElement),
                        child: Image.asset(ImageRes.crossIcon)),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                ]),
          ),
        ));
  }
}
