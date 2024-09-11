import 'package:dags_user/Common/Services/misc_models.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/utils/coupon_model.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Features/HomeScreen/Provider/home_service_state.dart';
import 'package:dags_user/Features/HomeScreen/Provider/home_services_notifier.dart';
import 'package:dags_user/Features/OrderDetailScreen/Controller/order_det_controller.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Common/Services/api_services.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/coupon_provider.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/utils/nearestVendorModel.dart';
import '../../../Common/widgets/app_shadow.dart';
import '../../../Common/widgets/text_widgets.dart';

class OrderDetails extends ConsumerStatefulWidget {
  const OrderDetails({super.key});

  @override
  ConsumerState<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails> {
  NearestVendorModel? data;
  bool isLoading = false;
  bool isLoading02 = false;
  late OrderDetController controller;
  int itemTotalComplete = 0;
  int deliveryCharges = 0;
  bool isOrderModelTotalDone = false;
  Charges? charges;
  Map<int, Map<String, dynamic>> serviceWithDetailsMap = {};
  List<Service> services = [];
  List<Coupon> couponsList = [];
  var ordersMap = {};
  bool madeOnce = false;
  double totalDiscount = 0;
  int selectedIndex = -1;
  String? selectedCouponName = null;

  @override
  Future<void> didChangeDependencies() async {
    setState(() {
      isLoading = true;
    });
    controller = OrderDetController();
    data = await controller.findNearestVendor();
    fetchOrderDetail();
    charges = await API.fetchCharges();
    ref.read(servicesProvider.notifier).fetchServices();
    ref.read(couponsProvider.notifier).fetchCoupons();
    if (data != null) {
      deliveryCharges = data?.deliveryFee ?? 30;
      deliveryCharges *= 2;
      OrderModel.deliveryFee = deliveryCharges;
    }
    setState(() {
      isLoading = false;
    });
    // Future.delayed(const Duration(seconds: 4), () {
    //
    // });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    setState(() {
      itemTotalComplete = OrderModel.itemTotal;
    });
    super.initState();
  }

  void fetchOrderDetail() {
    ordersMap = ServiceManager().getAllServicesWithIdAndItems();
  }

  Widget serviceAndItems({dynamic service}) {
    final serviceName = service['serviceName'];
    final List<Item?> itemList = service['items'] as List<Item?>;
    bool itemExists = false;
    for (var i = 0; i < itemList.length; i++) {
      if (itemList[i]?.quantity != 0) {
        itemExists = true;
        // int? price = itemList[i]?.unitPrice;
        // int? quantity = itemList[i]?.quantity;
        // OrderModel.itemTotal += (price! * quantity!);
      }
    }
    return (itemList.isNotEmpty && itemExists)
        ? Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: textcustomnormal(
                    text: serviceName,
                    fontSize: 20,
                    fontfamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListView.builder(
                  itemBuilder: (_, index) {
                    final itemInHand = itemList[index];
                    if (itemInHand != null) {
                      var itemName = itemInHand.name;
                      final itemPrice = itemInHand.unitPrice;
                      final itemQuantity = itemInHand.quantity;
                      final itemIcon = itemInHand.itemIcon;
                      return (itemQuantity == 0)
                          ? const SizedBox()
                          : Center(
                              child: Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                                padding:
                                    EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                                width: 370.w,
                                height: 65.h,
                                decoration: appBoxDecoration(
                                    radius: 10.h,
                                    borderColor: Colors.grey.shade300,
                                    borderWidth: 1.5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40.h,
                                          width: 40.h,
                                          decoration: appBoxDecoration(
                                              color: const Color(
                                                0xffFFE9B5,
                                              ),
                                              borderColor: Colors.grey.shade300,
                                              borderWidth: 1.h,
                                              radius: 8.h),
                                          child: Center(
                                            child: Image.network(
                                                height: 25.h,
                                                itemIcon ??
                                                    ImageRes.noImageFound),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            textcustomnormal(
                                              text: itemName!,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontfamily: "Inter",
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            textcustomnormal(
                                              text: "₹ $itemPrice.00",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontfamily: "Inter",
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                                      child: textcustomnormal(
                                        text: "Quantity: $itemQuantity",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        fontfamily: "Inter",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    } else {
                      return const Center(
                          child: textcustomnormal(
                              text: "No items for this service"));
                    }
                  },
                  itemCount: itemList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              ],
            ),
          )
        : const SizedBox();
  }

  void setServicesMap() {
    int key = 0;
    for (var service in services) {
      if (ordersMap.containsKey(service.id)) {
        final tempService = ServiceManager().getServiceById(service.id!);
        if (tempService != null) {
          setState(() {
            serviceWithDetailsMap[key] = tempService;
          });
          key++;
        }
      }
    }
  }

  Map<String, dynamic> createOrdersJson() {
    final phoneNumber =
        Global.storageServices.getString(AppConstants.userPhoneNumber);
    List<OrderForApiBody> orders = [];
    List<String> orderPics = [];
    orderPics.add(OrderModel.image);
    if (kDebugMode) {
      print(orderPics);
    }
    ordersMap.forEach((id, serviceData) {
      var items = serviceData['items'] as List<Item>;
      for (var item in items) {
        if (item.quantity > 0) {
          orders.add(OrderForApiBody(
              itemId: item.itemId!,
              qty: item.quantity,
              serviceId: serviceData['serviceId'],
              unitPrice: item.unitPrice!));
        }
      }
    });
    if (kDebugMode) {
      print(OrderModel.date.toIso8601String());
    }
    return {
      'vendorId': OrderModel.vendorId,
      'deliveryFee': ((OrderModel.deliveryFee) / 2).truncate(),
      "transactionId": "",
      'deliveryType': OrderModel.deliveryType,
      'phone': phoneNumber,
      'pickupDate': OrderModel.date.toIso8601String(),
      'orders': orders.map((order) => order.toJson()).toList(),
      'notes': OrderModel.note,
      'orderPics': orderPics,
      'orderLocation': OrderModel.orderAddress,
      'coupon': selectedCouponName
    };
  }

  Future<bool> handlePopUp(BuildContext context) async {
    bool dialog = false;
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
          title: const textcustomnormal(
            text: 'Do you really want to go back?',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontfamily: "Inter",
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                dialog = true;
                Navigator.pop(context, true);
              },
              child: const textcustomnormal(
                text: 'Yes',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontfamily: "Inter",
                color: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () {
                dialog = false;
                Navigator.pop(context, true);
                // Navigator.pop(context, false);
              },
              child: const textcustomnormal(
                text: 'No',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontfamily: "Inter",
                color: Color(0xff1d254e),
              ),
            ),
          ],
        );
      },
    );
    return dialog;
  }

  @override
  Widget build(BuildContext context) {
    services = ref.watch(servicesProvider);
    double tax = 0;
    double platFormFee = 0;
    if (services.isNotEmpty && ordersMap.isNotEmpty) {
      setServicesMap();
    }
    if (charges != null) {
      double? taxPercent = charges?.tax ?? 18;
      tax = (((itemTotalComplete + deliveryCharges) * taxPercent) / 100);
      platFormFee = charges?.platFormFee ?? 0;
    }
    couponsList = ref.watch(couponsProvider);
    OrderModel.vendorId = data?.closestVendor?.vendorId ?? "VE000005";
    final double grandTotal =
        itemTotalComplete + deliveryCharges + tax - totalDiscount + platFormFee;
    OrderModel.totalAmount = grandTotal;
    return WillPopScope(
      onWillPop: () {
        return handlePopUp(context);
      },
      child: Scaffold(
        appBar: buildAppBarWithCustomLeadingNavigation(
            context: context,
            goToApplication: () async {
              bool x = await handlePopUp(context);
              if (x) Navigator.pop(context);
            }),
        body: (isLoading)
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    termsHeading("Order Details"),
                    SizedBox(
                      height: 10.h,
                    ),
                    dashLine(
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    (totalDiscount != 0 && selectedCouponName != null)
                        ? Container(
                            color: Colors.green,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.h, vertical: 5.h),
                            child: textcustomnormal(
                              text: "You saved ₹$totalDiscount on this order",
                              fontSize: 16,
                              align: TextAlign.center,
                              fontfamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5.h,
                    ),
                    ListView.builder(
                      itemBuilder: (_, index) {
                        final serviceForBuild = serviceWithDetailsMap[index];
                        if (serviceForBuild != null) {
                          return serviceAndItems(service: serviceForBuild);
                        }
                        return null;
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    dashLine(
                      color: const Color(0xffFFCC57),
                      height: 1.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: const textcustomnormal(
                        text: "Coupons",
                        fontSize: 20,
                        fontfamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.h, vertical: 10.h),
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: appBoxDecoration(
                            radius: 12.h,
                            borderColor: AppColors.primaryElement,
                            borderWidth: 1.5.h,
                            color: const Color(0xffFFFAEE)),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: Border(
                                top: BorderSide(width: 0.0),
                              ),
                              backgroundColor: Colors.white,
                              useSafeArea: true,
                              context: context,
                              builder: (BuildContext context) {
                                // for (var coupon in couponsList) {
                                //   if (itemTotalComplete >= coupon.minAmount) {
                                //     madeOnce = true;
                                //   }
                                return couponsList.isNotEmpty
                                    ? Container(
                                        height: 400.h,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: const textcustomnormal(
                                                text: "All available coupons",
                                                fontSize: 20,
                                                fontfamily: "Inter",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Container(
                                              height: 350.h,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: couponsList.length,
                                                  itemBuilder: (_, index) {
                                                    return couponCard(
                                                        index, context);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: textcustomnormal(
                                        text:
                                            "No Coupons available for this price range",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontfamily: "Inter",
                                        color: Colors.black,
                                      ));
                              },
                            );
                          },
                          child: textcustomnormal(
                            text: "View all available coupons >",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontfamily: "Poppins",
                            align: TextAlign.start,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(
                      height: 15.h,
                    ),
                    (totalDiscount != 0 && selectedCouponName != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.h),
                                  child: textcustomnormal(
                                    align: TextAlign.start,
                                    text:
                                        'Coupon "$selectedCouponName" applied ₹$totalDiscount discount added',
                                    fontSize: 16,
                                    fontfamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        totalDiscount = 0;
                                        selectedIndex = -1;
                                        selectedCouponName = null;
                                      });
                                      Fluttertoast.showToast(
                                          msg: 'Coupon has been removed',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor:
                                              AppColors.primaryElement,
                                          textColor: Colors.black);
                                    },
                                    child: textcustomnormal(
                                      text: "Remove",
                                      fontSize: 16,
                                      fontfamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: const textcustomnormal(
                        text: "Amount",
                        fontSize: 20,
                        fontfamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        // height: 155.h,
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: appBoxDecoration(
                            radius: 12.h,
                            borderColor: AppColors.primaryElement,
                            borderWidth: 1.5.h,
                            color: const Color(0xffFFFAEE)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const textcustomnormal(
                                  text: "Items:",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                ),
                                textcustomnormal(
                                  text: "₹ $itemTotalComplete.00",
                                  fontWeight: FontWeight.w600,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textcustomnormal(
                                      text: "Shipping Charges:",
                                      fontWeight: FontWeight.w700,
                                      fontfamily: "Inter",
                                      fontSize: 16,
                                      align: TextAlign.left,
                                    ),
                                    textcustomnormal(
                                      text:
                                          "(${OrderModel.deliveryType[0].toUpperCase()}${OrderModel.deliveryType.substring(1)} delivery)",
                                      fontWeight: FontWeight.w500,
                                      fontfamily: "Inter",
                                      fontSize: 14,
                                      align: TextAlign.left,
                                    ),
                                  ],
                                ),
                                textcustomnormal(
                                  text: "₹ ${OrderModel.deliveryFee}.00",
                                  fontWeight: FontWeight.w600,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const textcustomnormal(
                                  text: "Tax:",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                ),
                                textcustomnormal(
                                  text: "₹ ${tax.toStringAsFixed(2)}",
                                  fontWeight: FontWeight.w600,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const textcustomnormal(
                                  text: "Platform Fee:",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                ),
                                textcustomnormal(
                                  text: "₹ ${platFormFee.toStringAsFixed(2)}",
                                  fontWeight: FontWeight.w600,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            (totalDiscount!=0)?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const textcustomnormal(
                                  text: "Discount:",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                ),
                                textcustomnormal(
                                  text:
                                      "- ₹ ${totalDiscount.toStringAsFixed(2)}",
                                  fontWeight: FontWeight.w600,
                                  fontfamily: "Inter",
                                  fontSize: 16,
                                  color: Colors.green,
                                )
                              ],
                            ):SizedBox(),
                            SizedBox(
                              height: 5.h,
                            ),
                            dashLine(
                              height: 1.h,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const textcustomnormal(
                                  text: "Total:",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 20,
                                ),
                                textcustomnormal(
                                  text: "₹ ${grandTotal.toStringAsFixed(2)}",
                                  fontWeight: FontWeight.w700,
                                  fontfamily: "Inter",
                                  fontSize: 20,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    (itemTotalComplete != 0)
                        ? !isLoading02
                            ? Center(
                                child: appButtons(
                                    height: 50.h,
                                    width: 340.w,
                                    buttonText: "Confirm Order",
                                    buttonTextColor: Colors.black,
                                    anyWayDoor: () async {
                                      setState(() {
                                        isLoading02 = true;
                                      });
                                      bool isServiceAvailable = await API.checkServiceAvailability();
                                      if(isServiceAvailable) {
                                        Map<String, dynamic> dataToPost =
                                        createOrdersJson();
                                        bool gotSuccess = await controller
                                            .handleCreateOrder(dataToPost);
                                        if (gotSuccess) {
                                          if (kDebugMode) {
                                            print('really created order');
                                          }
                                          navKey.currentState
                                              ?.pushNamedAndRemoveUntil(
                                              "/razorpay_scr",
                                                  (route) => false);
                                        }
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                            msg: "We are currently not serving in your area.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: AppColors.primaryElement,
                                            textColor: Colors.black,
                                            fontSize: 16.0);
                                      }
                                      setState(() {
                                        isLoading02 = false;
                                      });
                                    },
                                    buttonBorderWidth: 1.5.h))
                            : const Center(child: CircularProgressIndicator())
                        : const SizedBox(),
                    SizedBox(
                      height: 100.h,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget couponCard(int index, BuildContext context) {
    final currentCoupon = couponsList[index];
    final minAmount = currentCoupon.minAmount.toDouble();
    final couponName = currentCoupon.couponName;
    final couponDiscountPer = currentCoupon.couponDiscount;
    final couponDesc = currentCoupon.description;
    final isFlat = currentCoupon.isFlat;
    final maxDiscount = currentCoupon.maxDiscount;
    double discountShown = 0;
    if (isFlat) {
      discountShown = maxDiscount.toDouble();
    } else {
      discountShown = (itemTotalComplete * couponDiscountPer) / 100;
      if (discountShown >= maxDiscount) {
        debugPrint('discount shown is greater than max.');
        discountShown = maxDiscount.toDouble();
      }
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        decoration: appBoxDecoration(
            radius: 12.h,
            borderColor: AppColors.primaryElement,
            borderWidth: 1.5.h,
            color: const Color(0xffFFFAEE)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: textcustomnormal(
                      text: "Save up to ₹ ${discountShown} with '$couponName'",
                      fontSize: 15,
                      fontfamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: textcustomnormal(
                      text: couponDesc,
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      align: TextAlign.start,
                      color: Colors.grey.shade600,
                    ),
                  )
                ]),
            (selectedIndex == -1)
                ? appButtons(
                    buttonText: "APPLY",
                    buttonTextColor: (itemTotalComplete >= minAmount)
                        ? Colors.greenAccent
                        : Colors.grey.shade300,
                    buttonColor: Colors.white,
                    buttonBorderWidth: 1.h,
                    borderColor: (itemTotalComplete >= minAmount)
                        ? Colors.greenAccent
                        : Colors.grey.shade300,
                    width: 60.w,
                    height: 30.h,
                    buttonTextSize: 12,
                    anyWayDoor: () {
                      if (itemTotalComplete >= minAmount) {
                        setState(() {
                          selectedIndex = index;
                          totalDiscount = discountShown;
                          selectedCouponName = couponName;
                        });
                        Fluttertoast.showToast(
                            msg: 'Coupon has been applied successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: AppColors.primaryElement,
                            textColor: Colors.black);
                        Navigator.pop(context);
                      }
                    })
                : (selectedIndex == index)
                    ? appButtons(
                        buttonText: "REMOVE",
                        buttonTextColor: Colors.redAccent,
                        buttonColor: Colors.white,
                        buttonBorderWidth: 1.h,
                        borderColor: Colors.redAccent,
                        width: 65.w,
                        height: 30.h,
                        buttonTextSize: 12,
                        anyWayDoor: () {
                          setState(() {
                            totalDiscount = 0;
                            selectedIndex = -1;
                            selectedCouponName = null;
                          });
                          Fluttertoast.showToast(
                              msg: 'Coupon has been removed',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: AppColors.primaryElement,
                              textColor: Colors.black);
                          Navigator.pop(context);
                        })
                    : SizedBox()
          ],
        ));
  }
}
