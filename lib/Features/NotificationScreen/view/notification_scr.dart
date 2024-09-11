import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/Features/NotificationScreen/provider/notification_provider.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../provider/notification_model.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  List<AppNotification> notificationList = [];

  @override
  void initState() {
    ref.read(notificationsProvider.notifier).fetchNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationsProvider);
    if (notificationState != null) {
      notificationList = notificationState;
      // var objList = notificationList.reversed ;
      // notificationList = List.from(objList);
    }
    return WillPopScope(
      onWillPop: () async {
        navKey.currentState
            ?.pushNamedAndRemoveUntil("/application_scr", (routes) => false);
        return false;
      },
      child: Scaffold(
        appBar: buildAppBarWithCustomLeadingNavigation(
            context: context,
            goToApplication: () {
              navKey.currentState?.pushNamedAndRemoveUntil(
                  "/application_scr", (route) => false);
            }),
        body: (notificationList.isNotEmpty)
            ? SingleChildScrollView(
                  child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: termsHeading("Notifications")),
                    SizedBox(
                      height: 10.h,
                    ),
                    dashLine(
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListView.builder(
                      itemBuilder: (_, index) {
                        final currentNot = notificationList[index];
                        final DateTime dtTime = currentNot.createdAt;
                        final notificationTime =
                            DateFormat('E, d MMM yyyy h:mm a').format(dtTime);
                        return NotificationCard(
                          title: currentNot.title,
                          time: notificationTime,
                          icon: Icons.notifications,
                        );
                      },
                      itemCount: notificationList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 20.h),
                    //     child: const textcustomnormal(
                    //       text: "Today",
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 16,
                    //       fontfamily: "Poppins",
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 10.w,
                    //     right: 10.w,
                    //   ),
                    //   child: const NotificationCard(
                    //     title: 'Master, your laundry is done!',
                    //     time: 'Just Now',
                    //     icon: Icons.check_circle_outline,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: '50% off your next laundry',
                    //     time: '3:00 PM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: 'Check out brand new offers',
                    //     time: '11:00 AM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 16.h),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 20.h),
                    //     child: const DateLabel(date: '06 Oct 2023'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 10.w,
                    //     right: 10.w,
                    //   ),
                    //   child: const NotificationCard(
                    //     title: 'Master, your laundry is done!',
                    //     time: 'Just Now',
                    //     icon: Icons.check_circle_outline,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: '50% off your next laundry',
                    //     time: '3:00 PM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: 'Check out brand new offers',
                    //     time: '11:00 AM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: 'A free laundry coupon, yay!',
                    //     time: '8:52 AM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 5.h),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: 'Check the coupons available',
                    //     time: '8:50 AM',
                    //     icon: Icons.local_offer,
                    //   ),
                    // ),
                    // SizedBox(height: 16.h),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(left: 20.h),
                    //     child: const DateLabel(date: '05 Oct 2023'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   child: const NotificationCard(
                    //     title: 'Master, Your laundry is done!',
                    //     time: '2:00 PM',
                    //     icon: Icons.check_circle_outline,
                    //   ),
                    // ),
                    SizedBox(
                      height: 100.h,
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 80,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Center(
                        child: textcustomnormal(
                      text: "No notifications available at this moment.",
                      fontSize: 20,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w600,
                    )),
                  ],
                )),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const NotificationCard(
      {super.key, required this.title, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.h),
      child: Card(
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Inter",
                  color: Colors.black,
                  letterSpacing: 0.3)),
          subtitle: Text(time,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  fontFamily: "Inter",
                  color: Colors.black,
                  letterSpacing: 0.3)),
        ),
      ),
    );
  }
}

class DateLabel extends StatelessWidget {
  final String date;

  const DateLabel({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: textcustomnormal(
          text: date,
          fontfamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ));
  }
}
