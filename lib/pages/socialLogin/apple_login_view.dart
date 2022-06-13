import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/pages/socialLogin/social_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppleLoginView extends GetView<SocialLoginController> {
  const AppleLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebView(
              initialUrl: ApiService.APPLE_LOGIN_URL,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {},
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
              onProgress: (int progress) {},
              onPageStarted: (String url) {
                if (url.startsWith("berbe-app-apple-login://apple")) {
                  controller.appleLoginAndroid(url);
                }
              },
              onPageFinished: (String url) {
                controller.isLoading.value = false;
              },
              gestureNavigationEnabled: true,
              backgroundColor: colorWhite,
            ),
            Obx(
              () => Visibility(
                  visible: controller.isLoading.value,
                  child: const Center(
                      child: CircularProgressIndicator(color: primaryColor))),
            )
          ],
        ),
      ),
    );
  }
}
