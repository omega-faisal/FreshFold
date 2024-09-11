import 'package:dags_user/Common/widgets/app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Common/Services/api_services.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late InAppWebViewController webController;
  double pageProgress = 0;
  String? webContent;

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  Future<void> fetchData() async {
   try {
      final charges = await API.fetchCharges();
      final initialString = charges.privacyPolicy;
      setState(() {
        webContent = """<html>
        <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content ="width = device-width, user-scalable=no, initial-scale=1.0">
        </head>
        <body>
        $initialString
        </body>
        </html>""";
      });
      if (kDebugMode) {
        print(webContent);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching charges: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context),
        body: Stack(
          children: [
            (webContent != null)
                ? Padding(
                    padding:
                        EdgeInsets.only(top: 0.h, left: 15.w, right: 15.w),
                    child: InAppWebView(
                        initialData: InAppWebViewInitialData(data: webContent!),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webController = controller;
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            pageProgress = progress / 100;
                          });
                        }),
                  )
                : const Center(
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ],
        ));
  }
}
