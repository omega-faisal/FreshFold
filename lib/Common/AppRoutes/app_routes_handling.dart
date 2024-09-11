import 'package:dags_user/Features/AboutUsScreen/view/about_us.dart';
import 'package:dags_user/Features/AddAddress/view/addadress.dart';
import 'package:dags_user/Features/AddressDetails/view/address_det.dart';
import 'package:dags_user/Features/AddressForOrder/view/address_for_order.dart';
import 'package:dags_user/Features/AddressScreen/view/address_scr.dart';
import 'package:dags_user/Features/DeliveryOptionsScreen/view/delivery_options.dart';
import 'package:dags_user/Features/HelpSupportScreen/view/help_support.dart';
import 'package:dags_user/Features/InstructionScreen/view/instruction_scr.dart';
import 'package:dags_user/Features/LocationRequest/view/location_req.dart';
import 'package:dags_user/Features/NotificationScreen/view/notification_scr.dart';
import 'package:dags_user/Features/Onboarding/view/welcome.dart';
import 'package:dags_user/Features/OrderConfirmScreen/view/order_confirm_scr.dart';
import 'package:dags_user/Features/OrderDetailScreen/view/order_detail.dart';
import 'package:dags_user/Features/OrderInfo/view/order_info_scr.dart';
import 'package:dags_user/Features/Orderscreen/view/order_scr.dart';
import 'package:dags_user/Features/ProfileScreen/view/profile.dart';
import 'package:dags_user/Features/ServiceScreen/view/service_scr.dart';
import 'package:dags_user/Features/ShareApp/view/share_app_scr.dart';
import 'package:dags_user/Features/SignIn/view/sign_in_scr.dart';
import 'package:dags_user/Features/SignUp/view/sign_up_scr.dart';
import 'package:dags_user/Features/SplashScreen02/view/splash_scr_view02.dart';
import 'package:dags_user/Features/TermsScreen/view/terms_scr.dart';
import 'package:dags_user/Features/TimeSlotScreen/view/timeslot.dart';
import 'package:dags_user/Features/UploadImageScreen/view/upload_image_scr.dart';
import 'package:dags_user/Features/application/view/application.dart';
import 'package:dags_user/Features/otp%20screen/view/otp_scr.dart';
import 'package:dags_user/Features/policyScreens/view/privacy_scr.dart';
import 'package:dags_user/Features/policyScreens/view/refund_policy.dart';
import 'package:dags_user/Features/policyScreens/view/shipping_policy.dart';
import 'package:dags_user/razorpay_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Features/SplashScreen/view/splash_scr_view.dart';
import '../Services/global.dart';
import 'appRoutes.dart';

class appPages {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(
          path: AppRoutes.SPLASH,
          page: const ProviderScope(child: SplashScreen())),
      RouteEntity(
          path: AppRoutes.SPLASH02,
          page: const ProviderScope(child: SplashScreen02())),
      RouteEntity(
          path: AppRoutes.WELCOME, page: ProviderScope(child: Welcome())),
      RouteEntity(
          path: AppRoutes.SIGNUP,
          page: const ProviderScope(child: SignUpScreen())),
      RouteEntity(
          path: AppRoutes.SIGNIN,
          page: const ProviderScope(child: SignINScreen())),
      RouteEntity(
          path: AppRoutes.OTPSCREEN,
          page: const ProviderScope(child: OtpScreen())),
      RouteEntity(
          path: AppRoutes.LOCATIONSCREEN,
          page: const ProviderScope(child: LocationRequestScreen())),
      RouteEntity(
          path: AppRoutes.SHAREAPPSCREEN,
          page: const ProviderScope(child: ShareAppScreen())),
      RouteEntity(
          path: AppRoutes.DELIVERYOPTIONSSCREEN,
          page: const ProviderScope(child: DeliveryOptions())),
      RouteEntity(
          path: AppRoutes.TIMESLOTSCREEN,
          page: const ProviderScope(child: TimeSlot())),
      RouteEntity(
          path: AppRoutes.ORDERCONFIRMSCREEN,
          page: const ProviderScope(child: OrderConfirmScreen())),
      RouteEntity(
          path: AppRoutes.PROFILESCREEN,
          page: const ProviderScope(child: ProfileScreen())),
      RouteEntity(
          path: AppRoutes.ADDRESSSCREEN,
          page: const ProviderScope(child: AddressScreen())),
      RouteEntity(
          path: AppRoutes.ADDRESSDETAILSSCREEN,
          page: const ProviderScope(child: AddressDetails())),
      RouteEntity(
          path: AppRoutes.HELPSCREEN,
          page: const ProviderScope(child: HelpScreen())),
      RouteEntity(
          path: AppRoutes.TERMSSCREEN,
          page: const ProviderScope(child: TermsScreen())),
      RouteEntity(
          path: AppRoutes.PRIVACYSCREEN,
          page:  const ProviderScope(child: PrivacyScreen())),
      RouteEntity(
          path: AppRoutes.APPLICATION,
          page: const ProviderScope(child: Application())),
      RouteEntity(
          path: AppRoutes.SERVICE,
          page: const ProviderScope(child: ServiceScreen())),
      RouteEntity(
          path: AppRoutes.UPLOADIMAGE,
          page: const ProviderScope(child: UploadImage())),
      RouteEntity(
          path: AppRoutes.INSTRUCTIONSCREEN,
          page: const ProviderScope(child: InstructionScreen())),
      RouteEntity(
          path: AppRoutes.NOTIFICATION,
          page: const ProviderScope(child: NotificationScreen())),
      RouteEntity(
          path: AppRoutes.ORDERINFO,
          page: const ProviderScope(child: OrderInfo())),
      RouteEntity(
          path: AppRoutes.ABOUTUS,
          page: const ProviderScope(child: AboutUsScreen())),
      RouteEntity(
          path: AppRoutes.ORDERDETAIL,
          page: const ProviderScope(child: OrderDetails())),
      RouteEntity(
          path: AppRoutes.ADDADDRESS,
          page: const ProviderScope(child: AddAddress())),
      RouteEntity(
          path: AppRoutes.REFUNDPOLICY,
          page: const ProviderScope(child: RefundScreen())),
      RouteEntity(
          path: AppRoutes.SHIPPINGPOLICY,
          page: const ProviderScope(child: ShippingScreen())),
      RouteEntity(
          path: AppRoutes.RAZORPAY,
          page: const ProviderScope(child: RazorpayScreen())),
      RouteEntity(
          path: AppRoutes.ADDRESSFORORDERSCREEN,
          page: const ProviderScope(child: AddressForOrder())),
      RouteEntity(
          path: AppRoutes.ORDERSCREEN,
          page: const ProviderScope(child: OrderScreen())),
];
  }

  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (kDebugMode) {
      print('current route name is ${settings.name}');
    }
    if (settings.name != null) {
      var result = routes().where((element) => element.path == settings.name);

      bool userRegisteredEarlier =
          Global.storageServices.getUserRegisteredEarlier();
      bool locationGranted = Global.storageServices.getLocationGranted();

      bool openedFirstTime = Global.storageServices.getOpenedFirstTime();

      /// NOW HERE WE ARE CHECKING IF THE CURRENT ROUTE IS WELCOME PAGE ROUTE AND Device has been opened earlier...
      /// and if it is true then navigate the user to the login screen..not to the welcome screen anymore
      /// NOTE- THIS INFORMATION WHETHER THE DEVICE IS OPENED FIRST TIME OR NOT WILL BE STORED UNDER THE getDeviceOpenedEarlier()
      /// FUNCTION OF STORAGE SERVICES WHICH IS CAPABLE OF STORING THE STATE EVEN IF THE APP IS CLOSED....
      ///  THIS STATE OF getDeviceOpenedEarlier() WILL BE STORED IN THE PERMANENT MEMORY...
      if (result.first.path == AppRoutes.WELCOME && !openedFirstTime) {
        {
          bool isLoggedIn = userRegisteredEarlier;
          if (isLoggedIn) {
            bool isLocationGranted = locationGranted;
            if (isLocationGranted) {
              return MaterialPageRoute(
                  builder: (_) =>
                      const ProviderScope(child: Application()),
                  settings: settings);
            } else {
              return MaterialPageRoute(
                  builder: (_) =>
                      const ProviderScope(child: LocationRequestScreen()),
                  settings: settings);
            }
          } else {
            return MaterialPageRoute(
                builder: (_) => const ProviderScope(child: SignUpScreen()),
                settings: settings);
          }
        }
      } else {
        return MaterialPageRoute(
            builder: (_) => result.first.page, settings: settings);
      }
    }
    return MaterialPageRoute(
        builder: (_) => const ProviderScope(child: SplashScreen()),
        settings: settings);
  }
}

class RouteEntity {
  String path;
  Widget page;

  RouteEntity({required this.path, required this.page});
}
