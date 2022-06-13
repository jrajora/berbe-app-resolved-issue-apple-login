import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_images.dart';
import 'package:berbe/pages/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlackBackground,
      body: Center(
        child: SizedBox(
          width: 350.0,
          height: 350.0,
          child: Stack(
            children: [
              Lottie.asset(splashAnimation),
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                child: Image.asset(splashLogo),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
