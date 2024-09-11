import 'dart:convert';
import 'dart:io';
import 'package:dags_user/Common/utils/app_colors.dart';
import 'package:dags_user/Common/utils/orderModel.dart';
import 'package:dags_user/Common/widgets/app_button_widgets.dart';
import 'package:dags_user/Common/widgets/app_shadow.dart';
import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Common/utils/image_res.dart';
import '../provider/camera_notifier.dart';

class UploadImage extends ConsumerStatefulWidget {
  const UploadImage({super.key});

  @override
  ConsumerState<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends ConsumerState<UploadImage> {
  File? image;
  late String documentImage;
  bool isUploaded = false;

  Future<bool> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 10);
      if (image == null) return false;
      final imageTemp = File(image.path);
      Uint8List _bytes = await imageTemp.readAsBytes();
      documentImage = base64.encode(_bytes);
      OrderModel.image = documentImage;
      setState(() {
        this.image = imageTemp;
        ref.read(cameraNotifierProvider.notifier).changeState(true);
      });

      return true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image due to $e error");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePicked = ref.watch(cameraNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              const Center(
                child: textcustomnormal(
                  text: "Upload Image",
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontfamily: "Inter",
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Center(
                child: textcustomnormal(
                  text: "Please Upload Image of the clothes",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontfamily: "Inter",
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Center(
                  child: imagePicked
                      ? Container(
                          padding: EdgeInsets.all(20.h),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.h),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                                height: 360.h,
                                width: 330.w,
                              )))
                      : Image.asset(
                          ImageRes.uploadimage,
                          height: 300.h,
                          width: 300.w,
                        )),
              SizedBox(
                height: 30.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final result = await pickImage();
                    setState(() {
                      isUploaded = result;
                    });
                    if (kDebugMode) {
                      print("Image uploaded: $isUploaded");
                    }
                  },
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    decoration: appBoxDecoration(
                        radius: 20.h,
                        borderWidth: 1.0,
                        borderColor: Colors.black,
                        color: const Color(0xffFFCC57)),
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 30.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Center(
                child: appButtons(
                    anyWayDoor: () {
                      if (!isUploaded) {
                        setState(() {
                          OrderModel.image = "";
                        });
                      }
                      navKey.currentState?.pushNamed(
                        "/instruction_scr",
                      );
                    },
                    buttonText: isUploaded ? "Submit" : "Skip",
                    buttonColor: const Color(0xffFFFAEE),
                    buttonTextColor: const Color(0xffFFCC57),
                    borderColor: AppColors.primaryElement,
                    buttonBorderWidth: 1.5.h,
                    width: 340.w,
                    height: 50.w),
              ),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
