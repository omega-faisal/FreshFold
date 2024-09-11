import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/utils/constants.dart';
import '../../../Common/widgets/app_bar.dart';
import '../../../Common/widgets/app_shadow.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../../AddressScreen/Provider/fetch_address_provider.dart';

class AddressForOrder extends ConsumerStatefulWidget {
  const AddressForOrder({super.key});

  @override
  ConsumerState<AddressForOrder> createState() => _AddressForOrderState();
}

class _AddressForOrderState extends ConsumerState<AddressForOrder> {
  final String phoneNumber =
      Global.storageServices.getString(AppConstants.userPhoneNumber);
  int selectedIndex = -1;
  String userAddress = '';

  @override
  void didChangeDependencies() {
    ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    List<dynamic> addresses = [];
    if (addressState != null) {
      addresses = addressState.address;
    }
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: (addresses.isNotEmpty)
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const textcustomnormal(
                      color: Color(0xff1C254E),
                      text: "Choose an address",
                      fontfamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  dashLine(
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  (addressState != null)
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          width: double.maxFinite,
                          // height: double.maxFinite,
                          child: ListView.builder(
                            itemBuilder: (_, index) {
                              bool isSelected = false;
                              return Center(
                                child: addressCard(addressState.address[index],
                                    index, isSelected),
                              );
                            },
                            itemCount: addressState.address.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: (selectedIndex == -1)
                        ? const SizedBox()
                        : appButtons(
                            buttonText: "Proceed to order",
                            buttonColor: AppColors.primaryElement,
                            buttonBorderWidth: 1.5.h,
                            buttonTextColor: Colors.black,
                            height: 50.h,
                            width: 340.w,
                            anyWayDoor: () {
                              OrderModel.orderAddress =
                                  addressState!.address[selectedIndex];
                              if (kDebugMode) {
                                print(
                                    'address for order is -> ${OrderModel.orderAddress}');
                              }
                              navKey.currentState
                                  ?.pushNamed('/order_detail_scr');
                            }),
                  ),
                  SizedBox(
                    height: 100.h,
                  )
                ],
              ),
            )
          : const Center(
              child: Center(
                  child: textcustomnormal(
                text: "No addresses available, Please add one.",
                fontSize: 20,
                fontfamily: "Inter",
                fontWeight: FontWeight.w600,
              )),
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryElement,
          onPressed: () {
            navKey.currentState?.pushNamed("/add_address_scr").then((_) {
              ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
            });
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget addressCard(String address, int index, bool isSelected) {
    Color addressColor = (selectedIndex == index)
        ? AppColors.primaryElement
        : AppColors.documentButtonBg;
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          height: 70.h,
          width: 360.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: appBoxDecoration(
              color: addressColor, borderColor: Colors.grey.shade400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textcustomnormal(
                fontWeight: FontWeight.w600,
                fontfamily: "Inter",
                fontSize: 18,
                text: "Address ${index + 1}",
                color: const Color(0xff1C254E),
              ),
              Text(
                address,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: "Inter",
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
//  fontWeight: FontWeight.w400,
//                 fontfamily: "Inter",
//                 fontSize: 14,
//                 text: address,
//                 color: Colors.black,