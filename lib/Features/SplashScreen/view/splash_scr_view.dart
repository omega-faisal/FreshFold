import 'package:dags_user/Common/utils/image_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///timer shown to illustrate the process
    Future.delayed(const Duration(seconds: 1), () {
      navKey.currentState
          ?.pushNamedAndRemoveUntil('/splash_02', (route) => false);});
   }
  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
      designSize: Size(ScreenWidth, ScreenHeight),
      builder: (context, child)=>SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFFCC57),
        body: Container(

          alignment: Alignment.center,
          child:Image.asset(ImageRes.userlogoimage),
        )
      ),
    ));
  }
}
