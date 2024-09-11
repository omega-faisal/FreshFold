import 'dart:async';

import 'package:dags_user/Common/Services/api_services.dart';
import 'package:dags_user/Common/utils/app_colors.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/app_shadow.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../../Common/utils/image_res.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../../Orderscreen/Provider/order_model.dart';
import '../../Orderscreen/Provider/order_provider.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class OrderInfo extends ConsumerStatefulWidget {
  const OrderInfo({super.key});

  @override
  ConsumerState<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends ConsumerState<OrderInfo> {
  double rating = 0.0;
  bool feedbackPosted = false;
  String deliveryType = '';

  TextEditingController feedbackController = TextEditingController();

  @override
  void didChangeDependencies() {
    ref.read(orderNotifierProvider.notifier).loadOrders();
    super.didChangeDependencies();
  }

  Widget createOrderInfo(List<Order> activeOrders, List<Order> pastOrders,
      String orderId, bool isActive) {
    DateFormat dateFormatter;
    String deliveryDate = '';
    String orderStatus = '';
    double deliveryFee = 0;
    double orderAmount = 0;
    double taxes = 0;
    double? discount = 0;
    double finalAmount = 0.0;
    double platFormFee = 0.0;
    List<Item> items = [];
    if (isActive) {
      activeOrders.forEach((order) {
        if (kDebugMode) {
          // print("inside for each");
        }
        if (order.orderId == orderId) {
          if (kDebugMode) {
            // print("for each working very well");
          }
          dateFormatter = DateFormat('E, d MMM yyyy');
          if (order.deliveryDate != null) {
            if (kDebugMode) {
              // print("delivery date is not null");
            }
            if (order.orderStatus.last.status == "readyToPickup")
              deliveryDate = dateFormatter.format(order.pickupDate!).toString();
            else
              deliveryDate =
                  dateFormatter.format(order.deliveryDate!).toString();
          } else {
            deliveryDate = '';
          }
          orderStatus = setCorrectGrammer(order.orderStatus.last.status);
          deliveryFee = order.deliveryFee;
          orderAmount = order.amount;
          items = order.items;
          taxes = (order.taxes);
          finalAmount = order.finalAmount;
          platFormFee = order.platformFee;
          deliveryType = order.deliveryType;
          if (order.discount != null) {
            discount = order.discount;
          }
          debugPrint('delivery type from widget is -> ${order.deliveryType}');
        }
      });
    } else {
      pastOrders.forEach((order) {
        if (order.orderId == orderId) {
          dateFormatter = DateFormat('E, d MMM yyyy');
          if (order.deliveryDate != null) {
            deliveryDate = dateFormatter.format(order.deliveryDate!).toString();
          } else {
            deliveryDate = '';
          }
          orderStatus = setCorrectGrammer(order.orderStatus.last.status);
          deliveryFee = order.deliveryFee;
          orderAmount = order.amount;
          items = order.items;
          taxes = (order.taxes);
          deliveryType = order.deliveryType;
          finalAmount = order.finalAmount;
          platFormFee = order.platformFee;
          if (order.discount != null) {
            discount = order.discount;
          }
          debugPrint('delivery type from widget is -> ${order.deliveryType}');
        }
      });
    }
    return orderDetailCard02(
        orderId,
        deliveryDate,
        orderAmount,
        deliveryFee,
        items,
        orderStatus,
        taxes,
        discount!,
        deliveryType,
        finalAmount,
        platFormFee);
  }

  Widget setDataForTimeline(List<Order> activeOrders, List<Order> pastOrders,
      String orderId, bool isActive) {
    List<OrderStatus> statusList = [];

    if (isActive) {
      activeOrders.forEach((order) {
        if (order.orderId == orderId) {
          statusList = order.orderStatus;
          if (kDebugMode) {
            // print('status list from correct block is -> $statusList');
          }
        }
      });
      if (kDebugMode) {
        // print('order status is -> $statusList');
      }
      return buildTrackOrder(statusList);
    } else {
      pastOrders.forEach((order) {
        if (order.orderId == orderId) {
          statusList = order.orderStatus;
          if (kDebugMode) {
            // print('status list from correct block is -> $statusList');
          }
        }
      });
      if (kDebugMode) {
        // print('order status is -> $statusList');
      }
      return buildTrackOrder(statusList);
    }
  }

  String setCorrectGrammer(String status) {
    String corrected = '';
    switch (status) {
      case 'pending':
        {
          corrected = "Pending";
        }
        break;
      case 'initiated':
        {
          corrected = "Initiated";
        }
        break;
      case 'readyToPickup':
        {
          corrected = "Ready To Pickup";
        }
        break;
      case 'pickedUp':
        {
          corrected = "Picked Up";
        }
        break;
      case 'readyToDelivery':
        {
          corrected = "Ready To Delivery";
        }
        break;
      case 'outOfDelivery':
        {
          corrected = "Out For Delivery";
        }
        break;
      case 'delivered':
        {
          corrected = "Delivered";
        }
        break;
      case 'cancelled':
        {
          corrected = "Cancelled";
        }
        break;
      case 'refunded':
        {
          corrected = "Refunded";
        }
        break;
      case 'cleaning':
        {
          corrected = "Laundry In Progress";
        }
      default:
        {
          corrected = " ";
        }
        break;
    }
    return corrected;
  }

  Widget buildTrackOrder(List<OrderStatus> status) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final weekDay = DateFormat('EEEE');
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        width: double.maxFinite,
        child: Timeline.tileBuilder(
            // primary: false,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            theme: TimelineThemeData(
                nodePosition: 0.25,
                connectorTheme:
                    ConnectorThemeData(space: 5.h, color: Colors.green),
                indicatorTheme: const IndicatorThemeData(
                  color: Colors.blueGrey,
                  position: 0.5,
                  size: 15.0,
                )),
            builder: TimelineTileBuilder(
              indicatorBuilder: ((context, index) => Indicator.dot(
                    color: Colors.greenAccent,
                  )),
              startConnectorBuilder: ((context, index) => Connector.solidLine(
                    color: Colors.grey,
                  )),
              endConnectorBuilder: ((context, index) => Connector.solidLine(
                    color: Colors.grey,
                  )),
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, index) {
                final String correctStatus =
                    setCorrectGrammer(status[index].status);
                return Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textcustomnormal(
                        align: TextAlign.start,
                        text: correctStatus,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontfamily: "Inter",
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textcustomnormal(
                            align: TextAlign.start,
                            text: weekDay.format(status[index].time!),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontfamily: "Inter",
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          textcustomnormal(
                            align: TextAlign.start,
                            text: dateFormatter.format(status[index].time!),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontfamily: "Inter",
                            color: Colors.black,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: status.length,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String? orderId = data['orderId'];
    bool? isActive = data['active'] ?? false;
    final orderResponse = ref.watch(orderNotifierProvider);
    final activeOrders = orderResponse.activeOrders;
    final pastOrders = orderResponse.pastOrders;
    debugPrint('delivery type is -> $deliveryType');
    return WillPopScope(
      onWillPop: () async {
        navKey.currentState
            ?.pushNamedAndRemoveUntil("/order_scr", (routes) => false);
        return false;
      },
      child: Scaffold(
        appBar: buildAppBarWithCustomLeadingNavigation(
            context: context,
            goToApplication: () {
              navKey.currentState
                  ?.pushNamedAndRemoveUntil("/order_scr", (routes) => false);
            }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              termsHeading("Order Detail"),
              SizedBox(
                height: 10.h,
              ),
              dashLine(
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 10.h,
              ),
              createOrderInfo(activeOrders, pastOrders, orderId!, isActive!),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        termsHeading("Track Order"),
                        SizedBox(
                          height: 20.h,
                        ),
                        setDataForTimeline(
                            activeOrders, pastOrders, orderId, isActive),
                      ],
                    ),
                  ),
                ),
              ),
              CancelTimer(activeOrders: activeOrders, orderId: orderId),
              SizedBox(
                height: 50.h,
              ),
              for (int i = 0; i < pastOrders.length; i++)
                if (pastOrders[i].orderId == orderId &&
                    pastOrders[i].orderStatus.last.status == "delivered")
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: (pastOrders[i].feedbackRating == 0 &&
                            !feedbackPosted)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: termsHeading("Rate this order:")),
                              SizedBox(
                                height: 20.h,
                              ),
                              PannableRatingBar(
                                enablePixelsCompensation: false,
                                minRating: 1,
                                maxRating: 5,
                                rate: rating,
                                items: List.generate(
                                    5,
                                    (index) => const RatingWidget(
                                          selectedColor:
                                              Color.fromARGB(255, 255, 186, 59),
                                          unSelectedColor: Color.fromARGB(
                                              255, 211, 211, 211),
                                          child: Icon(
                                            Icons.star,
                                            size: 48,
                                          ),
                                        )),
                                onChanged: (value) {
                                  // the rating value is updated on tap or drag.
                                  setState(() {
                                    rating = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: TextFormField(
                                  controller: feedbackController,
                                  minLines: 3,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Provide your valuable feedback",
                                      enabledBorder: OutlineInputBorder(
                                          gapPadding: 5,
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 12, 122),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          gapPadding: 5,
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 7, 0, 105),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      border: OutlineInputBorder(
                                          gapPadding: 5,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              appButtons(
                                height: 50.h,
                                width: 340.w,
                                buttonText: "Submit",
                                buttonTextColor: Colors.black,
                                anyWayDoor: () async {
                                  if (rating != 0) {
                                    // print("----->$rating");
                                    // print(
                                    // "Feedback: ${feedbackController.text}");
                                    await API.sendFeedback(orderId,
                                        feedbackController.text, rating);
                                    setState(() {
                                      feedbackPosted = true;
                                      // print(feedbackPosted);
                                      pastOrders[i].feedbackRating = rating;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          )
                        : Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 3),
                                  child: textcustomnormal(
                                    color: const Color(0xff1C254E),
                                    text:
                                        "You provided this order \n ${pastOrders[i].feedbackRating} Rating.",
                                    fontWeight: FontWeight.w700,
                                    fontfamily: "Inter",
                                    fontSize: 22,
                                  ),
                                ),
                                PannableRatingBar(
                                  enablePixelsCompensation: false,
                                  minRating: 1,
                                  maxRating: 5,
                                  rate: pastOrders[i].feedbackRating!,
                                  items: List.generate(
                                      5,
                                      (index) => const RatingWidget(
                                            selectedColor: Color.fromARGB(
                                                255, 255, 186, 59),
                                            unSelectedColor: Color.fromARGB(
                                                255, 211, 211, 211),
                                            child: Icon(
                                              Icons.star,
                                              size: 28,
                                            ),
                                          )),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

// class OrderCard extends StatefulWidget {
//   final String orderId;
//   final List<OrderDetail> orderDetails;
//
//   const OrderCard(
//       {super.key, required this.orderId, required this.orderDetails});
//
//   @override
//   State<OrderCard> createState() => _OrderCardState();
// }
//
// class _OrderCardState extends State<OrderCard> {
//   bool isExpanded = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return isExpanded
//         ? SizedBox(
//           height: 320.h,
//           child: Card(
//               color: const Color(0xffFFF4DA),
//               child: Padding(
//                   padding: EdgeInsets.only(
//                       left: 16.w, right: 5.w, top: 5.h, bottom: 5.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             widget.orderId,
//                             style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.w600,
//                                 fontFamily: "Inter"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 isExpanded = false;
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.white,
//                             ),
//                             child: Container(
//                               height: 35.h,
//                               width: 130.w,
//                               decoration: appBoxDecoration(
//                                   color: const Color(0xffFFCC57),
//                                   borderColor: const Color(0xffFFCC57)),
//                               child: Center(
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 5.w,
//                                     ),
//                                     const textcustomnormal(
//                                       text: "Order Details",
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                       color: Colors.white,
//                                       fontfamily: "Inter",
//                                     ),
//                                     const Icon(Icons.expand_less),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.h),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: widget.orderDetails.map((detail) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.check_circle,
//                                       color: Colors.teal, size: 28.h),
//                                   SizedBox(width: 8.w),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         detail.status,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(detail.date),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               if (widget.orderDetails.indexOf(detail) !=
//                                   widget.orderDetails.length - 1)
//                                 Container(
//                                   margin: EdgeInsets.only(left: 13.w),
//                                   height: 24.h,
//                                   width: 2.w,
//                                   color: Colors.teal[100],
//                                 ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   )),
//             ),
//         )
//         : Container(
//             padding: EdgeInsets.all(10.h),
//             height: 70.h,
//             decoration: appBoxDecoration(
//                 color: const Color(0xffFFF4DA),
//                 radius: 12.h,
//                 borderWidth: 0.0,
//                 borderColor: const Color(0xffFFF4DA)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.orderId,
//                   style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: "Inter"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       isExpanded = true;
//                     });
//                   },
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Container(
//                     height: 35.h,
//                     width: 130.w,
//                     decoration: appBoxDecoration(
//                         color: const Color(0xffFFCC57),
//                         borderColor: const Color(0xffFFCC57)),
//                     child: Center(
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 5.w,
//                           ),
//                           const textcustomnormal(
//                             text: "Order Details",
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             color: Colors.white,
//                             fontfamily: "Inter",
//                           ),
//                           const Icon(Icons.expand_more),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }
Widget orderDetailCard02(
    String orderID,
    String deliveryDate,
    double orderAmount,
    double deliveryFee,
    List<Item> items,
    String orderStatus,
    double taxes,
    double discount,
    String deliveryType,
    double finalAmount,
    double platformFee) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 20.h, right: 20.h),
        decoration: appBoxDecoration(
            color: Colors.white, borderWidth: 1.5.h, radius: 10.h),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.h),
                    topRight: Radius.circular(10.h),
                  ),
                  border: Border.all(color: Colors.transparent),
                  color: Colors.yellow.shade700,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textcustomnormal(
                            text: "#$orderID",
                            fontSize: 20,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                          textcustomnormal(
                            text:
                                '${(orderStatus == "Ready To Pickup") ? "Pickup" : "Delivery"}: $deliveryDate',
                            fontSize: 16,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          orderStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1d254e)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final item = items[index];
                    if (kDebugMode) {
                      // print(item.itemName);
                    }
                    if (kDebugMode) {
                      // print(item.serviceName);
                    }
                    return Container(
                      child: ListTile(
                          title: textcustomnormal(
                            text: '${item.itemName} x ${item.qty}' ?? '',
                            fontSize: 18,
                            align: TextAlign.start,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontfamily: "Inter",
                          ),
                          subtitle: textcustomnormal(
                            text: item.serviceName ?? '',
                            fontSize: 12,
                            align: TextAlign.start,
                            fontWeight: FontWeight.w400,
                            fontfamily: "Inter",
                          ),
                          trailing: textcustomnormal(
                            text:
                                "₹ ${(item.unitPrice * item.qty).toStringAsFixed(2)}",
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontfamily: "Inter",
                          )),
                    );
                  },
                  itemCount: items.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              dashLine(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (deliveryType == 'express')
                        ? Padding(
                          padding:  EdgeInsets.only(bottom: 8.0),
                          child: Row(
                              children: [
                                Image.asset(
                                  ImageRes.expressicon,
                                  height: 25.h,
                                  width: 25.h,
                                ),
                                SizedBox(width: 10,),
                                textcustomnormal(
                                  text: "Express Order",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                              ],
                            ),
                        )
                        : SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "Items Total :",
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textcustomnormal(
                          text: "₹ ${orderAmount.toStringAsFixed(2)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "Delivery Fee :",
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textcustomnormal(
                          text: "₹ ${deliveryFee.toStringAsFixed(2)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "Platform Fee :",
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textcustomnormal(
                          text: "₹ ${platformFee.toStringAsFixed(2)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "GST:",
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        textcustomnormal(
                          text: "₹ ${taxes.toStringAsFixed(2)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "Discount:",
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        textcustomnormal(
                          text: "₹ ${discount.toStringAsFixed(2)}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    const dashLine(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const textcustomnormal(
                          text: "Grand Total:",
                          fontWeight: FontWeight.w700,
                          fontfamily: "Inter",
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        textcustomnormal(
                          text: "₹ " + finalAmount.toStringAsFixed(2),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontfamily: "Inter",
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ])),
  );
}

class CancelTimer extends StatefulWidget {
  List<Order> activeOrders;
  String orderId;

  CancelTimer({super.key, required this.activeOrders, required this.orderId});

  @override
  State<CancelTimer> createState() => _CancelTimerState();
}

class _CancelTimerState extends State<CancelTimer> {
  var time = -1;
  Timer? timer;
  int minute = 0, second = 0;
  int cancelTimeAllowed = 0;
  DateTime orderDate = DateTime.now();
  DateTime nowdate = DateTime.now();

  void runTimer() async {
    if (time > 0) {
      minute = (time / 60).truncate();
      second = time - minute * 60;
    }
    while (time > 0) {
      await Future.delayed(Duration(seconds: 1), () {
        if (second <= 0) {
          second = 59;
          minute--;
        } else {
          second--;
        }
        if (minute <= 0) minute = 0;
      });
      setState(() {
        time--;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cancelTimeAllowed = cancelTimeAllowed;
    orderDate = DateTime.now();
    nowdate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (time == -1) {
      nowdate = DateTime(nowdate.year, nowdate.month, nowdate.day,
              nowdate.hour + 5, nowdate.minute + 30, nowdate.second)
          .toUtc();
      // DateFormat dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
      for (int k = 0; k < widget.activeOrders.length; k++) {
        if (widget.activeOrders[k].orderId == widget.orderId) {
          orderDate = widget.activeOrders[k].orderDate.toUtc();
          // orderDate = DateTime(2024, 7, 10, 14, 22, 00);
          time = (nowdate.millisecondsSinceEpoch -
                  orderDate.millisecondsSinceEpoch) ~/
              1000;
          setState(() {
            time = cancelTimeAllowed - time;
          });
          // print(time);
        }
      }
      // print(orderDate);
      // print(nowdate);
      if (time <= cancelTimeAllowed) {
        runTimer();
      }
    }
    return !(time > 300 || time <= 0)
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) => Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                    ),
                                    Text(
                                      "Cancel Order",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade100),
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            // size: 15,
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    time = (nowdate.millisecondsSinceEpoch -
                                            orderDate.millisecondsSinceEpoch) ~/
                                        1000;
                                    if (time <= cancelTimeAllowed) {
                                      API.cancelRefundOrder(
                                          orderId: widget.orderId);
                                      Navigator.pop(context);
                                      navKey.currentState
                                          ?.pushNamedAndRemoveUntil(
                                              "/order_scr", (routes) => false);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Cannot cancel order after 5 minutes of order confirmation",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              AppColors.primaryElement,
                                          textColor: Colors.black,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        "Cancel This Order",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Order can be cancelled in ",
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      ),
                      Text(
                        "0$minute:${second.toString().length == 1 ? '0' + second.toString() : second} minutes",
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
