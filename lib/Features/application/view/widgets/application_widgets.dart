import 'package:dags_user/Features/AccountsScreen/view/accounts_scr.dart';
import 'package:dags_user/Features/HomeScreen/view/home_screen.dart';
import 'package:dags_user/Features/NotificationScreen/view/notification_scr.dart';
import 'package:dags_user/Features/Orderscreen/view/order_scr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Common/utils/app_colors.dart';
import '../../../../Common/widgets/app_shadow.dart';

var bottomTabs = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
      icon: SizedBox(
        width: 25.w,
        height: 25.h,
        child: Icon(Icons.home_outlined,color: const Color(0xff1C254E)),
      ),
      activeIcon: Container(
        alignment: Alignment.center,
        height: 35.h,
        width: 80.w,
        decoration:
            appBoxDecoration(radius: 30.h, borderColor: Colors.grey.shade300),
        child: Icon(Icons.home_outlined,color: const Color(0xff1C254E)),
      ),
      backgroundColor: AppColors.primaryBackground,
      label: "Home"),
  BottomNavigationBarItem(
      icon: SizedBox(
        width: 25.w,
        height: 25.h,
        child: Icon(Icons.notifications_active_outlined,color: const Color(0xff1C254E)),
      ),
      activeIcon: Container(
        alignment: Alignment.center,
        height: 35.h,
        width: 80.w,
        decoration:
            appBoxDecoration(radius: 30.h, borderColor: Colors.grey.shade300),
        child: Icon(Icons.notifications_active_outlined,color: const Color(0xff1C254E))
      ),
      backgroundColor: AppColors.primaryBackground,
      label: "Notification"),
  BottomNavigationBarItem(
      icon: SizedBox(
        width: 25.w,
        height: 25.h,
        child: Icon(Icons.shopping_cart_checkout_outlined,color: const Color(0xff1C254E))
      ),
      activeIcon: Container(
        alignment: Alignment.center,
        height: 35.h,
        width: 80.w,
        decoration:
            appBoxDecoration(radius: 30.h, borderColor: Colors.grey.shade300),
        child: Icon(Icons.shopping_cart_checkout_outlined,color: const Color(0xff1C254E)),
      ),
      backgroundColor: AppColors.primaryBackground,
      label: "Order"),
  BottomNavigationBarItem(
      icon: SizedBox(
        width: 25.w,
        height: 25.h,
        child: Icon(Icons.perm_identity_outlined,color: const Color(0xff1C254E)),
      ),
      activeIcon: Container(
        alignment: Alignment.center,
        height: 35.h,
        width: 80.w,
        decoration:
            appBoxDecoration(radius: 30.h, borderColor: Colors.grey.shade300),
        child:Icon(Icons.perm_identity_outlined)
      ),
      backgroundColor: AppColors.primaryBackground,
      label: "Profile"),
];

Widget appScreens({int index = 0}) {
  List<Widget> screens = [
    const HomeScreen(),
    const NotificationScreen(),
    const OrderScreen(),
    const AccountsScreen()
  ];
  return screens[index];
}
