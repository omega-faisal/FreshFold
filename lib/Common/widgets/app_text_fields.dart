import 'package:dags_user/Common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_shadow.dart';

Widget textLoginBox(
    {required String name,
    required String iconPath,
    String hintText = "Type your info",
    bool obsecureText = false,
    TextEditingController? controller,
    void Function(String value)? func}) {
  return ScreenUtilInit(
    builder: (context, child) => Container(
      padding: EdgeInsets.only(left: 29.h, right: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text14normal(text: name),
          Container(
            margin: EdgeInsets.only(top: 5.h),
            width: 370.w,
            height: 55.h,
            // color: Colors.red,
            decoration: appBoxDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //this row contains and text for text login field
              children: [
                // Container(
                //   margin: EdgeInsets.only(left: 16.w),
                //   child: appImage(
                //       imagePath: iconPath, width: 18.w, height: 18.h),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  width: 260.w,
                  height: 55.h,
                  child: TextField(
                      onChanged: (value) => func!(value),
                      keyboardType: TextInputType.multiline,
                      controller: controller,
                      // this is for decorating the text field
                      decoration: InputDecoration(
                          hintText: hintText,
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),

                          ///this is the default border active when not focused
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),

                          /// this is the focused border
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),

                          ///this will be used when a text field in disabled
                          disabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
                      maxLines: 1,
                      autocorrect: false,
                      obscureText: obsecureText),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget textLoginBoxWithDimensions(
    {String hintText = "Type in your info",
    TextEditingController? controller,
    bool obsecureText = false,
    void Function(String value)? func,
    String? Function(String value)? validator,
    double width = 260,
    double height = 55,
    TextInputType? keyboardType = TextInputType.multiline,
    AutovalidateMode? validateMode}) {
  return Container(
    width: width,
    alignment: Alignment.center,
    child: TextFormField(
      onChanged: (value) => func!(value),
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) => validator!(value!),
      autovalidateMode: validateMode,
      // this is for decorating the text field
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.h, 3.h, 0, 3),
          hintText: hintText,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade500,
            fontFamily: "Inter",
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),

          ///this is the default border active when not focused
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10)),

          /// this is the focused border
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),

          ///this will be used when a text field in disabled
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10))),
      maxLines: 1,
      autocorrect: false,
      obscureText: obsecureText,
    ),
  );
}
