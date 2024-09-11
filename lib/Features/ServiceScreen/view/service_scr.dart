import 'package:dags_user/Common/utils/app_colors.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Common/utils/image_res.dart';
import '../../../Common/utils/orderModel.dart';
import '../../../Common/widgets/app_shadow.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../../HomeScreen/Provider/home_service_state.dart';
import '../../HomeScreen/Provider/home_services_notifier.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  bool _isFirstBuild = true;
  List<Item> items02 = [];
  List<Service> services = [];
  int? selectedIndex;
  late int serviceIndex;
  late List<Service> initialServices;
  bool isLoading = true;
  bool isInitialLoaded = false;

  Future<void> setServiceMap(List<Service> services) async {
    for (var service in services) {
      ServiceManager().setServiceWithIdAndItems(service);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    await ref.read(servicesProvider.notifier).fetchServices();
  }

  void initialItems({int index = 0, required List<Service> initialServices}) {
    items02 = initialServices[index].items;
    setServiceMap(initialServices);
    setState(() {
      isInitialLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
    int? iniIndex = data['index'];
    services = ref.watch(servicesProvider);
    if (_isFirstBuild && services.isNotEmpty) {
      initialItems(index: iniIndex!, initialServices: services);
      serviceIndex = iniIndex;
      _isFirstBuild = false;
    }
    if (services.isNotEmpty && isInitialLoaded) {
      setState(() {
        isLoading = false;
      });
    }
    setServiceMap(services);

    return Scaffold(
      appBar: buildAppBarWithActionAndLeading(context: context),
      body: (isLoading)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  termsHeading("Add Items To Laundry"),
                  dashLine(color: Colors.grey.shade400),
                  SizedBox(height: 15.h),
                  Container(
                    width: 400.w,
                    color: Colors.grey.shade300,
                    height: 175.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.h, top: 10.h,right:20.h),
                          child: const textcustomnormal(
                            text: "Services",
                            fontWeight: FontWeight.w600,
                            fontfamily: "Inter",
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        (services.isEmpty)
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 15.w),
                                height: 110.h,
                                child: ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Color itemColor;
                                    if (index == selectedIndex) {
                                      itemColor = const Color(0xffFFD779);
                                    } else if (index == iniIndex &&
                                        selectedIndex == null) {
                                      itemColor = const Color(0xffFFD779);
                                    } else {
                                      itemColor = const Color(0xffF1E5D4);
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          items02 = services[index].items;
                                          serviceIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(2.w),
                                        padding: EdgeInsets.all(2.h),
                                        child: Card(
                                          shadowColor: Colors.grey.shade300,
                                          elevation: 0.0,
                                          clipBehavior: Clip.hardEdge,
                                          child: Container(
                                            padding: EdgeInsets.all(2.h),
                                            alignment: Alignment.center,
                                            width: 100.w,
                                            decoration: appBoxDecoration(
                                              color: itemColor,
                                              radius: 10,
                                              borderWidth: 0,
                                              borderColor:
                                                  const Color(0xffF2E6D5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 5.h),
                                                Center(
                                                  child: Image.network(
                                                    services[index]
                                                        .serviceIcon!,
                                                    fit: BoxFit.contain,
                                                    height: 45.h,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 2.h,
                                                      left: 2.w,
                                                      right: 2.w),
                                                  child: Center(
                                                    child: textcustomnormal(
                                                      text: services[index]
                                                          .serviceName!,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontfamily: "Inter",
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: services.length,
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const textcustomnormal(
                      text: "Items",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontfamily: "Inter",
                    ),
                  ),
                  (items02.isEmpty)
                      ? Container(
                          margin: EdgeInsets.only(top: 70.h),
                          child: const Center(
                            child: textcustomnormal(
                              text: "No items available for this service",
                              fontfamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (_, index) {
                            final key = items02[index].name;
                            final price = items02[index].unitPrice;
                            final serviceId = services[serviceIndex].id;
                            final itemId = items02[index].id;
                            final itemIcon = items02[index].itemIcon;
                            final dummyItem =
                                ServiceManager().getItem(serviceId!, itemId!);
                            return Center(
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
                                  borderWidth: 1.5.h,
                                ),
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
                                            color: const Color(0xffFFE9B5),
                                            borderColor: Colors.grey.shade300,
                                            borderWidth: 1.h,
                                            radius: 8.h,
                                          ),
                                          child: Center(
                                            child: (itemIcon == null ||
                                                    itemIcon.isEmpty)
                                                ? Image.network(
                                                    services[serviceIndex]
                                                        .serviceIcon!)
                                                : Image.network(itemIcon),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            textcustomnormal(
                                              text: key!,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontfamily: "Inter",
                                            ),
                                            SizedBox(height: 3.h),
                                            textcustomnormal(
                                              text: "₹ $price",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              fontfamily: "Inter",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    (dummyItem != null)
                                        ? dummyItem.quantity == 0
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    ServiceManager()
                                                        .incrementItemQuantity(
                                                            serviceId, itemId);
                                                  });
                                                },
                                                child: Image.asset(
                                                    ImageRes.addbuttonimage),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 15.h,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        ServiceManager()
                                                            .decrementItemQuantity(
                                                                serviceId,
                                                                itemId);
                                                      });
                                                    },
                                                  ),
                                                  textcustomnormal(
                                                    text: dummyItem.quantity
                                                        .toString(),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                    fontfamily: "Inter",
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 15.h,
                                                    ),
                                                    onPressed: () {
                                                      if (dummyItem.quantity <
                                                          10) {
                                                        setState(() {
                                                          ServiceManager()
                                                              .incrementItemQuantity(
                                                                  serviceId,
                                                                  itemId);
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No more ${dummyItem.name} can be added.',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                AppColors
                                                                    .primaryElement,
                                                            textColor:
                                                                Colors.black);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                ServiceManager()
                                                    .incrementItemQuantity(
                                                        serviceId, itemId);
                                              });
                                            },
                                            child: Image.asset(
                                                ImageRes.addbuttonimage),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: items02.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: appButtons(
                          buttonText: "Confirm",
                          height: 50.h,
                          width: 340.w,
                          anyWayDoor: () {
                            final serviceMap =
                                ServiceManager().getAllServicesWithIdAndItems();
                            if (serviceMap.isNotEmpty) {
                              int totalAmount = 0;
                              // navKey.currentState
                              //     ?.pushNamed("/upload_image_scr");
                              serviceMap.forEach((serviceId, service) {
                                // print(service + "------->");
                                for (int i = 0;
                                    i < service['items'].length;
                                    i++) {
                                  Item item = service['items'][i];
                                  totalAmount +=
                                      item.quantity * item.unitPrice!;
                                }
                              });
                              if (totalAmount >= AppConstants.minOrderAmount) {
                                OrderModel.itemTotal = totalAmount;
                                navKey.currentState
                                    ?.pushNamed("/upload_image_scr");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Add laundry items of Rs. ${AppConstants.minOrderAmount - totalAmount} more to place an order.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: AppColors.primaryElement,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              }
                            }
                          },
                          buttonTextColor: Colors.black,
                          borderColor: Colors.black,
                          buttonBorderWidth: 1.5.h)),
                  SizedBox(
                    height: 100.h,
                  )
                ],
              ),
            ),
    );
  }
}
