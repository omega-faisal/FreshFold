import 'package:dags_user/Common/utils/image_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';

class SplashScreen02 extends StatefulWidget {
  const SplashScreen02({super.key});

  @override
  State<SplashScreen02> createState() => _SplashScreen02State();
}

class _SplashScreen02State extends State<SplashScreen02> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///timer shown to illustrate the process
    Future.delayed(const Duration(seconds: 1), () {
      navKey.currentState
          ?.pushNamedAndRemoveUntil('/welcome_scr', (route) => false);    });
  }
  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
      designSize: Size(ScreenWidth, ScreenHeight),
      builder: (context, child)=>SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff1C254E),
        body: Container(
          alignment: Alignment.center,
          child:Image.asset(ImageRes.userlogo02image),
        )
      ),
    ));
  }
}
