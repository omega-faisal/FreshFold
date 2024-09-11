import 'dart:convert';
import 'dart:io';
import 'package:dags_user/Common/Services/api_services.dart';
import 'package:dags_user/Common/Services/global.dart';
import 'package:dags_user/Common/utils/constants.dart';
import 'package:dags_user/Features/AccountsScreen/Controller/account_controller.dart';
import 'package:dags_user/Features/AccountsScreen/provider/user_model.dart';
import 'package:dags_user/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Common/utils/app_colors.dart';
import '../../../Common/widgets/app_bar.dart';
import '../../../Common/widgets/app_button_widgets.dart';
import '../../../Common/widgets/text_widgets.dart';
import '../../UploadImageScreen/provider/camera_notifier.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  late AccountController controller;
  bool isNameReadable = false;
  bool isEmailReadable = false;
  String userName = '';
  String email = '';
  String userPhoneNo =
      Global.storageServices.getString(AppConstants.userPhoneNumber);
  String? profilePicPath;
  File? image;
  String? profileImage;
  bool fromServer = true;
  User? user;
  final formKey = GlobalKey<FormState>();

  Future<bool> pickImage() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (pickedImage == null) return false;
      final imageTemp = File(pickedImage.path);
      Uint8List _bytes = await imageTemp.readAsBytes();
      profileImage = base64.encode(_bytes);
      ref.read(cameraNotifierProvider.notifier).changeState(true);
      setState(() {
        this.image = imageTemp;
        fromServer = false;
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
  void initState() {
    controller = AccountController();
    fetchNewUser();
    super.initState();
  }

  void setTextFields(User? user) {
    debugPrint('called setTextField');
    debugPrint('${user?.profilePic}');

    bool isNameSet = Global.storageServices.getNameSet();
    String? fromServer = user?.name;
    if (isNameSet) {
      userName = Global.storageServices.getString(AppConstants.userName);
      isNameReadable = false;
    } else if (fromServer != null && fromServer.isNotEmpty) {
      userName = fromServer;
      isNameReadable = false;
    } else {
      userName = "";
      isNameReadable = false;
    }
    if (user?.email?.isEmpty ?? true) {
      email = "";
      isEmailReadable = false;
    } else {
      email = user!.email!;
      isEmailReadable = true;
    }
    if (user?.profilePic != null && user!.profilePic!.isNotEmpty) {
      setState(() {
        profilePicPath = user.profilePic;
      });
    }
    controller.nameController.text = userName;
    controller.phoneNoController.text = userPhoneNo;
    controller.emailController.text = email;
  }

  fetchNewUser() async {
    User? newUser = await API.fetchUser();
    setState(() {
      user = newUser;
      fromServer = true;
    });
    if (user != null) {
      setTextFields(user);
    } else {
      controller.emailController.text = email;
      controller.nameController.text = userName;
      controller.phoneNoController.text = userPhoneNo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePicked = ref.watch(cameraNotifierProvider);
    debugPrint('from build -> $profilePicPath');
    return WillPopScope(
      onWillPop: () async {
        navKey.currentState
            ?.pushNamedAndRemoveUntil("/application_scr", (routes) => false);
        return false;
      },
      child: Scaffold(
        appBar: buildAppBarWithCustomLeadingNavigation(goToApplication: () {
          navKey.currentState
              ?.pushNamedAndRemoveUntil("/application_scr", (route) => false);
        }),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20.w, 15.h, 0, 0),
                  child: const textcustomnormal(
                    text: "Profile Info",
                    fontfamily: "Inter",
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                dashLine(
                  color: Colors.grey.shade300,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 40.h, 0, 0),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            await pickImage();
                          },
                          child: Center(
                            child: Container(
                              child: CircleAvatar(
                                radius: 60.w,
                                backgroundImage: image != null
                                    ? FileImage(image!) as ImageProvider<Object>
                                    : profilePicPath != null
                                        ? NetworkImage(profilePicPath!)
                                            as ImageProvider<Object>
                                        : NetworkImage(
                                            "https://dagstechnology.in/uploads/important/blank_user.jpg",
                                          ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color.fromARGB(255, 0, 7, 112),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: eventTextField(
                        keyBoardType: TextInputType.text,
                        hintText: "Enter Name",
                        controller: controller.nameController,
                        readable: isNameReadable,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: eventTextField(
                        keyBoardType: TextInputType.number,
                        controller: controller.phoneNoController,
                        readable: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: eventTextField(
                          keyBoardType: TextInputType.emailAddress,
                          hintText: "Enter Email",
                          controller: controller.emailController,
                          readable: isEmailReadable,
                          validateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            debugPrint('value is ->>>$value');
                            RegExp regex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (!regex.hasMatch(value!)) {
                              return 'Please enter correct email address';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    appButtons(
                      buttonColor: imagePicked
                          ? Color(0xff1d254e)
                          : Colors.grey.shade200,
                      width: 200.w,
                      height: 50.h,
                      buttonTextColor:
                          imagePicked ? Colors.white : const Color(0xff1d254e),
                      buttonText: "Update Profile",
                      buttonBorderWidth: 1.h,
                      borderColor: Color(0xff1d254e),
                      buttonTextSize: 17,
                      anyWayDoor: () async {
                        if (formKey.currentState!.validate()) {
                          if (controller.emailController.text.isNotEmpty &&
                              controller.nameController.text.isNotEmpty) {
                            final email = controller.emailController.text;
                            final name = controller.nameController.text;
                            bool isSuccess = await API.updateProfile(
                                email, name,
                                profilePic: profileImage);
                            ref
                                .read(cameraNotifierProvider.notifier)
                                .changeState(false);
                            if (isSuccess) {
                              await fetchNewUser();
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please enter your details",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: AppColors.primaryElement,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please enter your details correctly.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppColors.primaryElement,
                            textColor: Colors.black,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget eventTextField(
    {TextInputType keyBoardType = TextInputType.text,
    required TextEditingController controller,
    String hintText = "Type in your info",
    required bool readable,
    String? Function(String? value)? validator,
    AutovalidateMode? validateMode}) {
  return Container(
    alignment: Alignment.center,
    width: 320.w,
    child: TextFormField(
      validator: validator,
      keyboardType: keyBoardType,
      controller: controller,
      autovalidateMode: validateMode,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(10.h, 3.h, 0, 3),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade500,
            fontFamily: "Inter",
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(10)),

          ///this is the default border active when not focused
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10)),

          /// this is the focused border
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(10)),

          ///this will be used when a text field in disabled
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10))),
      maxLines: 1,
      autocorrect: false,
      obscureText: false,
      readOnly: readable,
    ),
  );
}
