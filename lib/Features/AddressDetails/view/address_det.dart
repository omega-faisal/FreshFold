import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Features/AddressDetails/Controller/AddressDetailController.dart';
import 'package:dags_user/Features/AddressDetails/Provider/AddressDetailNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Common/widgets/app_text_fields.dart';
import '../../../Common/widgets/text_widgets.dart';

class AddressDetails extends ConsumerStatefulWidget {
  const AddressDetails({super.key});

  @override
  ConsumerState<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends ConsumerState<AddressDetails> {
  late AddressDetailController _controller;
  String addressLine01 = '';
  String addressLine02 = '';
  String postalCode = '';
  final formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _controller = AddressDetailController();
    super.didChangeDependencies();
  }

  void splitString(String address) {
    var brokenString = address.split(",");
    addressLine01 = brokenString[0];
    addressLine02 = brokenString[1];
    postalCode = brokenString[2];
    _controller.address01Controller.text = addressLine01;
    _controller.address02Controller.text = addressLine02;
    _controller.postalCodeController.text = postalCode;
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final index = data['index'] ?? 0;
    final String addressString = data['address'];
    splitString(addressString);
    return Scaffold(
      appBar: buildAppBar(context: context),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: const textcustomnormal(
                  color: Color(0xff1C254E),
                  text: "Update Address",
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
              Center(
                child: textLoginBoxWithDimensions(
                    height: 50.h,
                    width: 325.w,
                    hintText: "Flat No/Street/Locality",
                    controller: _controller.address01Controller,
                    validator: (value) {
                      RegExp regex = RegExp(r'^[a-zA-Z0-9\/,\- ]{5,}$');
                      if (!regex.hasMatch(value)) {
                        return "Enter a valid address.";
                      }
                      return null;
                    },
                    validateMode: AutovalidateMode.onUserInteraction,
                    func: (value) {
                      // String sanitizedText = value.replaceAll(',', '-');
                      ref
                          .read(addressDetailNotifierProvider.notifier)
                          .onAddressLine01Change(value);
                      // _controller.address01Controller.value =
                      //     TextEditingValue(text: sanitizedText);
                    }),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: textLoginBoxWithDimensions(
                    height: 50.h,
                    width: 325.w,
                    hintText: "City",
                    controller: _controller.address02Controller,
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^[a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*$');
                      if (!regex.hasMatch(value)) {
                        return "Enter a valid city name.";
                      }
                      return null;
                    },
                    validateMode: AutovalidateMode.onUserInteraction,
                    func: (value) {
                      RegExp regex = RegExp(
                          r'^[a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*[a-zA-Z][a-zA-Z ,]*$');
                      if (regex.hasMatch(value)) {
                        String sanitizedText = value.replaceAll(',', '-');
                        _controller.address02Controller.value =
                            TextEditingValue(text: sanitizedText);
                        ref
                            .read(addressDetailNotifierProvider.notifier)
                            .onAddressLine02Change(value);
                      }
                    }),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: textLoginBoxWithDimensions(
                    height: 50.h,
                    width: 325.w,
                    hintText: "Postal Code",
                    keyboardType: TextInputType.number,
                    controller: _controller.postalCodeController,
                    validator: (value) {
                      RegExp regex = RegExp(r'^\d{6}$');
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid postal code.';
                      }
                      if (value.length != 6) {
                        return "Enter valid postal code.";
                      }
                      return null;
                    },
                    validateMode: AutovalidateMode.onUserInteraction,
                    func: (value) {
                      String sanitizedText = value
                          .replaceAll(' ', '')
                          .replaceAll(',', '')
                          .replaceAll('-', '')
                          .replaceAll('.', '');
                      if (sanitizedText.length > 6) {
                        sanitizedText = sanitizedText.substring(0, 6);
                      }
                      _controller.postalCodeController.value =
                          TextEditingValue(text: sanitizedText);
                      ref
                          .read(addressDetailNotifierProvider.notifier)
                          .onCodeChange(value);
                    }),
              ),
              SizedBox(
                height: 180.h,
              ),
              Center(
                  child: appButtons(
                buttonText: "Save",
                anyWayDoor: () {
                  if (formKey.currentState!.validate()) {
                    _controller.updateAddressController(ref, index);
                  }
                },
                height: 50.h,
                width: 345.w,
                buttonTextColor: Colors.black,
                buttonBorderWidth: 2.h,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
