import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/Features/Orderscreen/Provider/order_model.dart';
import 'package:dags_user/Features/Orderscreen/Provider/order_provider.dart';
import 'package:dags_user/Features/Orderscreen/view/widgets/order_scr_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../Common/utils/image_res.dart';
import '../Provider/order_radio_notifier.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      ref.read(orderNotifierProvider.notifier).loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderResponse = ref.watch(orderNotifierProvider);
    bool isActive = ref.watch(orderRadioNotifierProvider);
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              termsHeading("Orders"),
              SizedBox(
                height: 10.h,
              ),
              dashLine(
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 10.h,
              ),
              radioSwipeableButton(
                  ref: ref,
                  selectRadio01: () {
                    setState(() {
                      ref
                          .read(orderRadioNotifierProvider.notifier)
                          .changeBool(true);
                    });
                  },
                  selectRadio02: () {
                    setState(() {
                      ref
                          .read(orderRadioNotifierProvider.notifier)
                          .changeBool(false);
                    });
                  }),
              (isActive)
                  ? Container(
                      child: (orderResponse.activeOrders.isEmpty)
                          ? Padding(
                              padding: EdgeInsets.only(top: 250.h),
                              child: const Center(
                                  child: textcustomnormal(
                                text: "No active orders available",
                                fontSize: 20,
                                fontfamily: "Inter",
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          : ListView.builder(
                              itemBuilder: (_, index) {
                                final order = orderResponse.activeOrders[index];
                                final deliveryType = order.deliveryType;
                                final orderDate =
                                    DateFormat('E, d MMM yyyy h:mm a')
                                        .format(order.orderDate);
                                return Center(
                                    child: orderPastDetailCard(
                                        order.orderId,
                                        orderDate,
                                        order.amount,
                                        order.orderStatus,
                                        order.items,
                                        order.deliveryFee.truncate(),
                                        order.taxes,
                                        true,
                                        deliveryType,
                                        order.finalAmount
                                    ));
                              },
                              itemCount: orderResponse.activeOrders.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                    )
                  : Container(
                      child: (orderResponse.pastOrders.isEmpty)
                          ? Padding(
                              padding: EdgeInsets.only(top: 250.h),
                              child: const Center(
                                  child: textcustomnormal(
                                text: "No order history available",
                                fontSize: 20,
                                fontfamily: "Inter",
                                fontWeight: FontWeight.w600,
                              )),
                            )
                          : ListView.builder(
                              itemBuilder: (_, index) {
                                final order = orderResponse.pastOrders[index];
                                final deliveryType = order.deliveryType;
                                final orderDate =
                                    DateFormat('E, d MMM yyyy h:mm a')
                                        .format(order.orderDate);
                                return Center(
                                    child: orderPastDetailCard(
                                        order.orderId,
                                        orderDate,
                                        order.amount,
                                        order.orderStatus,
                                        order.items,
                                        order.deliveryFee.truncate(),
                                        order.taxes,
                                        false,
                                        deliveryType,
                                        order.finalAmount));
                              },
                              itemCount: orderResponse.pastOrders.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ))
            ],
          ),
        ),
      ),
    );
  }
}

// class OrderCard extends StatefulWidget {
//   const OrderCard(
//       {super.key,
//       required this.orderId,
//       required this.orderDate,
//       required this.orderAmount,
//       required this.pickUpDate,
//       required this.index});
//
//   final String orderId;
//   final String orderDate;
//   final int orderAmount;
//   final String? pickUpDate;
//   final int index;
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
//     final orderId = widget.orderId;
//     final orderDate = widget.orderDate;
//     final orderAmount = widget.orderAmount;
//     String? pickupDate = widget.pickUpDate;
//     return Card(
//       margin: EdgeInsets.all(20.h),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 15.w, top: 10.h, right: 15.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 textcustomnormal(
//                   text: orderId,
//                   fontfamily: "Inter",
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 appButtons(
//                     buttonText: "View Detail",
//                     buttonTextColor: Colors.white,
//                     buttonColor: AppColors.primaryElement,
//                     borderColor: AppColors.primaryElement,
//                     buttonBorderWidth: 0.0,
//                     height: 34.h,
//                     width: 105.w,
//                     buttonTextSize: 16,
//                     anyWayDoor: () {
//                       navKey.currentState?.pushNamed("/order_info_scr",
//                           arguments: {'orderId': orderId});
//                     }),
//               ],
//             ),
//           ),
//           SizedBox(height: 10.h),
//           isExpanded
//               ? Container(
//                   padding: EdgeInsets.only(left: 15.w, top: 10.h, right: 15.w),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffFFF4DA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.h),
//                       topRight: Radius.circular(20.h),
//                     ),
//                     border: Border.all(
//                       color: const Color(0xffFFF4DA),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const textcustomnormal(
//                             text: "Dags Pickup",
//                             fontSize: 18,
//                             fontfamily: "Inter",
//                             fontWeight: FontWeight.w600,
//                             color: Colors.redAccent,
//                           ),
//                           Row(
//                             children: [
//                               const textcustomnormal(
//                                 text: "Pickup Request",
//                                 fontSize: 18,
//                                 fontfamily: "Inter",
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                               SizedBox(
//                                 width: 3.w,
//                               ),
//                               GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       isExpanded = false;
//                                     });
//                                   },
//                                   child: const Icon(Icons.keyboard_arrow_up))
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h),
//                       InfoRow(
//                         label: 'orderDate',
//                         value: orderDate,
//                       ),
//                       const InfoRow(
//                         label: 'Agent Assign',
//                         value: 'Uday (954-2304-878)',
//                       ),
//                       InfoRow(
//                         label: 'Actual Pickup Date',
//                         value: pickupDate ?? 'test data',
//                       ),
//                       InfoRow(
//                         label: 'Order Amount',
//                         value: orderAmount.toString(),
//                       ),
//                       const InfoRow(
//                         label: 'URL Tracker',
//                         value: 'Vh23459584j264wvnbhS83784',
//                         isLink: true,
//                       ),
//                     ],
//                   ),
//                 )
//               : Container(
//                   padding: EdgeInsets.only(left: 15.h, right: 15.h),
//                   height: 50.h,
//                   decoration: BoxDecoration(
//                     color: const Color(0xffFFF4DA),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10.h),
//                       topRight: Radius.circular(10.h),
//                       bottomRight: Radius.circular(10.h),
//                       bottomLeft: Radius.circular(10.h),
//                     ),
//                     border: Border.all(
//                       color: const Color(0xffFFF4DA),
//                     ),
//                   ),
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const textcustomnormal(
//                           text: "Dags Pickup",
//                           fontSize: 18,
//                           fontfamily: "Inter",
//                           fontWeight: FontWeight.w600,
//                           color: Colors.redAccent,
//                         ),
//                         Row(
//                           children: [
//                             const textcustomnormal(
//                               text: "Pickup Request",
//                               fontSize: 18,
//                               fontfamily: "Inter",
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                             SizedBox(
//                               width: 3.w,
//                             ),
//                             GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     isExpanded = true;
//                                   });
//                                 },
//                                 child: const Icon(Icons.keyboard_arrow_down))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//         ],
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isLink;
//
//   const InfoRow(
//       {super.key,
//       required this.label,
//       required this.value,
//       this.isLink = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 5.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//               flex: 3,
//               child: textcustomnormal(
//                 fontWeight: FontWeight.w500,
//                 fontfamily: "Inter",
//                 fontSize: 14,
//                 text: label,
//                 align: TextAlign.left,
//                 color: Colors.grey.shade400,
//               )),
//           Expanded(
//             flex: 5,
//             child: GestureDetector(
//               onTap: isLink
//                   ? () {
//                       // Implement your URL Tracker functionality here
//                     }
//                   : null,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: "Inter",
//                   color: isLink ? Colors.redAccent : Colors.black,
//                   decoration:
//                       isLink ? TextDecoration.underline : TextDecoration.none,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
    case 'cleaning':
      {
        corrected = "Laundry In Progress";
      }
      break;
    default:
      {
        corrected = " ";
      }
      break;
  }
  return corrected;
}

Widget orderPastDetailCard(
    String orderID,
    String orderDate,
    double orderAmount,
    List<OrderStatus> status,
    List<Item> items,
    int deliveryCharge,
    double taxes,
    bool isActive,
    String deliveryType,
    double finalAmount,) {
  final orderstatus = setCorrectGrammer(status.last.status);
  return GestureDetector(
    onTap: () {
      navKey.currentState?.pushNamed("/order_info_scr",
          arguments: {'orderId': orderID, 'active': isActive});
    },
    child: Container(
        width: 400.w,
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.maxFinite,
                color: const Color(0xffFFCC57),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textcustomnormal(
                            text: "#$orderID",
                            fontSize: 20,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                          textcustomnormal(
                            text: orderstatus,
                            fontSize: 18,
                            fontfamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    (deliveryType == 'express')
                        ? Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15.w),
                      child: Image.asset(ImageRes.expressicon,height: 30.h,width: 30.h,)
                    )
                        : SizedBox()
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30.w, 10.h, 0, 0),
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: textcustomnormal(
                        align: TextAlign.start,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontfamily: "Inter",
                        text:
                            '${item.qty} x ${item.itemName} (${item.serviceName})',
                      ),
                    );
                  },
                  itemCount: items.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              dashLine(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  text16normal(
                    text: orderDate,
                    fontWeight: FontWeight.w700,
                    fontfamily: "Inter",
                    color: Colors.grey.shade600,
                  ),
                  textcustomnormal(
                    text: "₹ ${finalAmount.toStringAsFixed(2)}",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontfamily: "Inter",
                    color: Colors.black,
                  ),
                ],
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
            ])),
  );
}
