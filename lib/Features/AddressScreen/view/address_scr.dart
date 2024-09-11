import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_shadow.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/Features/AddressScreen/Provider/fetch_address_provider.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/Services/global.dart';
import '../../../Common/utils/app_colors.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final String phoneNumber =
      Global.storageServices.getString(AppConstants.userPhoneNumber);

  @override
  void didChangeDependencies() {
    ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: SingleChildScrollView(
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
                text: "Saved Addresses",
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
                ? ListView.builder(
                    itemBuilder: (_, index) {
                      return addressCard(addressState.address[index], index);
                    },
                    itemCount: addressState.address.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  )
                : const Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 100.h,
            )
          ],
        ),
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

  Widget addressCard(String address, int index) {
    return Center(
      child: GestureDetector(
        onTap: () {
          navKey.currentState?.pushNamed('/address_det_scr', arguments: {
            "index": index,
            "address": address,
          }).then((_) {
            ref.read(addressProvider.notifier).fetchAddress(phoneNumber);
          });
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          height: 70.h,
          width: 360.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
          decoration: appBoxDecoration(
              color: AppColors.documentButtonBg,
              borderColor: Colors.grey.shade400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
