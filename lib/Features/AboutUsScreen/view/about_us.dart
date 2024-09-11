import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Common/utils/image_res.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            termsHeading("About Us"),
            SizedBox(
              height: 10.h,
            ),
            dashLine(
              color: Colors.grey.shade400,
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(child: Stack(
              children: [
                Image.asset(ImageRes.veryfyingImage,height: 350.h,width: MediaQuery.of(context).size.width*0.8,),
                Image.asset(ImageRes.userlogoimage,height: 120.h,width: 100.w,)
              ],
            )),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                child: const textcustomnormal(
                  text:
                      "Ditch the laundromat and reclaim your weekends. DagsWash picks up your dirty laundry and delivers it fresh and folded, right to your door. Get peace of mind with transparent pricing and secure online payment system.",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontfamily: "Inter",
                  align: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
                child: dashLine(
              width: 240.w,
              color: const Color(0xffFFCC57),
              height: 1.h,
            )),
            SizedBox(
              height: 40.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const textcustomnormal(
                    text: "Our Company",
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontfamily: "Inter",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                      child: Image.asset(
                    ImageRes.clothimage,
                    height: 150.h,
                    width: 320.w,
                    fit: BoxFit.fill,
                  )),
                  SizedBox(
                    height: 20.h,
                  ),
                  const textcustomnormal(
                    text:
                        "Lorem ipsum dolor sit amet consectetur. Faucibus ac dapibus phasellus purus malesuada. Faucibus fringilla purus sollicitudin suspendisse. Dignissim velit morbi dictum eleifend semper pharetra metus enim. ",
                    fontWeight: FontWeight.w500,
                    fontfamily: "Inter",
                    fontSize: 16,
                    align: TextAlign.left,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  const textcustomnormal(
                    text: "Our Goals",
                    fontSize: 20,
                    fontfamily: "Inter",
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const textcustomnormal(
                        fontWeight: FontWeight.w600,
                        fontfamily: "Inter",
                        fontSize: 16,
                        text: "Lorem ipsum ifid susin",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const textcustomnormal(
                        fontWeight: FontWeight.w600,
                        fontfamily: "Inter",
                        fontSize: 16,
                        text: "Lorem ipsum ifid susin",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const textcustomnormal(
                        fontWeight: FontWeight.w600,
                        fontfamily: "Inter",
                        fontSize: 16,
                        text: "Lorem ipsum ifid susin",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Center(
                child: dashLine(
              width: 240.w,
              color: const Color(0xffFFCC57),
              height: 1.h,
            )),
            SizedBox(
              height: 20.h,
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 20.h),
            //   child: const textcustomnormal(
            //     text: "Our Head",
            //     fontSize: 26,
            //     fontfamily: "Inter",
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 30.w, right: 30.w),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           ClipOval(
            //             child: Image.asset(
            //               ImageRes.clothimage,
            //               width: 150,
            //               height: 150,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           SizedBox(
            //             height: 10.h,
            //           ),
            //           Container(
            //             width: 130.w,
            //             margin: EdgeInsets.only(left: 25.w),
            //             child: const textcustomnormal(
            //               text:
            //                   "Lorem ipsum dolor sit amet consectetur. Faucibus ac dapibus phasellus purus malesuada.",
            //               fontWeight: FontWeight.w500,
            //               fontfamily: "Inter",
            //               fontSize: 16,
            //               align: TextAlign.left,
            //             ),
            //           )
            //         ],
            //       ),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           ClipOval(
            //             child: Image.asset(
            //               ImageRes.clothimage,
            //               width: 150,
            //               height: 150,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           SizedBox(
            //             height: 10.h,
            //           ),
            //           Container(
            //             width: 130.w,
            //             margin: EdgeInsets.only(left: 25.w),
            //             child: const textcustomnormal(
            //               text:
            //                   "Lorem ipsum dolor sit amet consectetur. Faucibus ac dapibus phasellus purus malesuada.",
            //               fontWeight: FontWeight.w500,
            //               fontfamily: "Inter",
            //               fontSize: 16,
            //               align: TextAlign.left,
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 50.h,
            // ),
            // Center(
            //     child: dashLine(
            //   width: 240.w,
            //   color: const Color(0xffFFCC57),
            //   height: 1.h,
            // )),
            SizedBox(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }
}
