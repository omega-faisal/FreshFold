import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/Features/TimeSlotScreen/provider/time_slot_model.dart';
import 'package:dags_user/Features/TimeSlotScreen/provider/time_slot_provider.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../Common/utils/app_colors.dart';

class TimeSlot extends ConsumerStatefulWidget {
  const TimeSlot({super.key});

  @override
  ConsumerState<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends ConsumerState<TimeSlot> {
  final nowDate = DateTime.now();
  String selectedTime = '';
  String selectedDate = '';
  bool isDateDone = false;
  bool isTimeDone = false;
  int count = 0;
  List<TimeSlotModel>? timeSlotsList = [];

  nextDate(DateTime presentDate, var days) {
    var nextDate = presentDate.add(Duration(days: days));
    return nextDate;
  }

  nextTime(int presentHour, var hours) {
    var result = presentHour + hours;
    return result;
  }

  @override
  void didChangeDependencies() {
    ref.read(timeSlotProvider.notifier).fetchTimeSlotData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = ref.watch(timeSlotProvider);
    if (timeSlots != null) {
      timeSlotsList = timeSlots;
    }
    DateTime dateToday = DateTime.now();
    final hourOnly = dateToday.hour;
    final dateFormatter = DateFormat('E, d MMM yyyy');
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            termsHeading("Choose Pickup Date/Time"),
            SizedBox(
              height: 10.h,
            ),
            dashLine(
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 60.h,
                padding: EdgeInsets.only(left: 15.h, right: 15.h),
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    if ((hourOnly + 1) < 18) {
                      return _buildDateChip(
                          dateFormatter.format(nextDate(dateToday, index)));
                    } else {
                      return _buildDateChip(
                          dateFormatter.format(nextDate(dateToday, index + 1)));
                    }
                  },
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            isDateDone?ListView.builder(
              itemBuilder: (_, index) {
                final currentTimeSlot = timeSlotsList![index];
                final initialTimeToCheck =
                    int.parse(currentTimeSlot.startTime.substring(0, 2));
                final lastTimeToCheck =
                    int.parse(currentTimeSlot.endTime.substring(0, 2));
                final initialTimeFromServer = (initialTimeToCheck <= 12)
                    ? initialTimeToCheck
                    : (initialTimeToCheck - 12);
                final finalTimeFromServer = (lastTimeToCheck <= 12)
                    ? lastTimeToCheck
                    : (lastTimeToCheck - 12);
                final isStartAmOrPm = (initialTimeToCheck <= 12) ? 'AM' : 'PM';
                final isEndAmOrPm = (lastTimeToCheck <= 12) ? 'AM' : 'PM';
                final slicedString = selectedDate.substring(5, 7);
                final slicedString02 = selectedDate.substring(8, 11);
                final selectedDateDay = int.parse(slicedString);
                final selectedDateMonth = getMonthFromString(slicedString02);

                if (selectedDateMonth > dateToday.month) {
                  return _buildTimeSlot(
                      "${initialTimeFromServer}:00 ${isStartAmOrPm} - ${finalTimeFromServer}:00 ${isEndAmOrPm}");
                } else if (selectedDateDay > dateToday.day) {
                  return _buildTimeSlot(
                      "${initialTimeFromServer}:00 ${isStartAmOrPm} - ${finalTimeFromServer}:00 ${isEndAmOrPm}");
                } else {
                  if (initialTimeToCheck > hourOnly) {
                    return _buildTimeSlot(
                        "${initialTimeFromServer}:00 ${isStartAmOrPm} - ${finalTimeFromServer}:00 ${isEndAmOrPm}");
                  }
                }
                return SizedBox();
                //
                // if (kDebugMode) {
                //   print(selectedDateMonth);
                // }
                // if (kDebugMode) {
                //   print('index is ->$index');
                // }
                // int timeToInitial = 10 + index;
                // if (kDebugMode) {
                //   print(timeToInitial);
                // }
                //
                // } else if (selectedDateDay > dateToday.day) {
                //   if (timeToInitial < 18) {
                //     return _buildTimeSlot(
                //         '$timeToInitial:00 - ${timeToInitial + 1}:00');
                //   }
                // } else {
                //   if (hourOnly < 10) {
                //     var timeToInitial = 10 + index;
                //     if (timeToInitial < 18) {
                //       return _buildTimeSlot(
                //           '$timeToInitial:00 - ${timeToInitial + 1}:00');
                //     }
                //   } else {
                //     var timeToShow = hourOnly + index + 1;
                //     if (timeToShow < 18) {
                //       return _buildTimeSlot(
                //           '$timeToShow:00 - ${timeToShow + 1}:00');
                //     }
                //   }
                //}
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlotsList!.length,
            ):SizedBox(),
            SizedBox(
              height: 30.h,
            ),
            Center(
                child: (isTimeDone && isDateDone)
                    ? appButtons(
                        buttonText: "Confirm",
                        buttonTextColor: Colors.black,
                        height: 50.h,
                        width: 340.w,
                        buttonBorderWidth: 1.5.h,
                        anyWayDoor: () {
                          if (!isDateDone || !isTimeDone) {
                            debugPrint('something is fishy.');
                            Fluttertoast.showToast(
                                msg:
                                    "Please select desired date and time to proceed.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColors.primaryElement,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          } else {
                            final int selectedDateMonth;
                            final forYear = DateTime.now();
                            int year = forYear.year;
                            final selectedDateDay =
                                selectedDate.substring(5, 7).trim();
                            debugPrint('selected date day is ->$selectedDateDay');
                            if(selectedDateDay.length==1)
                              {
                                selectedDateMonth = getMonthFromString(
                                    selectedDate.substring(7, 10));
                              }
                            else{
                              selectedDateMonth = getMonthFromString(
                                  selectedDate.substring(8, 11));
                            }
                            final String var01 =
                                "$selectedDateDay/$selectedDateMonth/$year";
                            debugPrint('selected date month is ->$selectedDateMonth');
                            final inputFormat = DateFormat('dd/MM/yyyy HH:mm');
                            final outputFormat = DateFormat('MM/dd/yyyy HH:mm');
                            debugPrint(selectedTime);
                            String newTime = selectedTime.split(' - ')[0].substring(0,4);
                            debugPrint(newTime);
                            String newDateAndTime =
                                var01 + " " +newTime;
                            DateTime dt01 = inputFormat.parse(newDateAndTime);
                            String dt02 = outputFormat.format(dt01);
                            DateTime parsedDate = outputFormat.parse(dt02);
                            OrderModel.date = parsedDate;
                            navKey.currentState
                                ?.pushNamed("/address_for_order_scr");
                          }
                        })
                    : const SizedBox()),
            SizedBox(height: 35.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(String date) {
    bool isSelected = date == selectedDate;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ChoiceChip(
        label: Text(date),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedTime = '';
            isTimeDone = false;
            selectedDate = date;
            isDateDone = true;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.amber,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    bool isSelected = time == selectedTime;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 35.h),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedTime = time;
              isTimeDone = true;
            });
          },
          child: ListTile(
            title: Text(time),
            leading: Radio<String>(
              value: time,
              groupValue: selectedTime,
              onChanged: (value) {
                setState(() {
                  selectedTime = value!;
                  isTimeDone = true;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: isSelected ? Colors.amber : Colors.grey),
              borderRadius: BorderRadius.circular(15.w),
            ),
            tileColor: isSelected ? Colors.amber[50] : Colors.white,
          ),
        ));
  }

  int getMonthFromString(String stringMonth) {
    int month = 0;
    switch (stringMonth) {
      case 'Jan':
        {
          month = 01;
        }
        break;
      case 'Feb':
        {
          month = 02;
        }
        break;
      case 'Mar':
        {
          month = 03;
        }
        break;
      case 'Apr':
        {
          month = 04;
        }
        break;
      case 'May':
        {
          month = 05;
        }
        break;
      case 'Jun':
        {
          month = 06;
        }
        break;
      case 'Jul':
        {
          month = 07;
        }
        break;
      case 'Aug':
        {
          month = 08;
        }
        break;
      case 'Sep':
        {
          month = 09;
        }
        break;
      case 'Oct':
        {
          month = 10;
        }
      case 'Nov':
        {
          month = 11;
        }
      case 'Dec':
        {
          month = 12;
        }
      default:
        {
          month = 0;
        }
        break;
    }
    return month;
  }
}
