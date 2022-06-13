import 'package:berbe/constants/app_images.dart';
import 'package:flutter/material.dart';

class DashboardBackground extends StatelessWidget {
  const DashboardBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
                width: 180,
                height: 180,
                child: Center(child: Image.asset(barbeLogo)))),
        Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
                width: 220,
                height: 220,
                child: Center(child: Image.asset(barbeLogo)))),
        Positioned.fill(
            child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.98),
                  Colors.black.withOpacity(0.5),
                ],
                begin: const Alignment(-1.0, -2.0),
                end: const Alignment(1.0, 2.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ))
      ],
    );
  }
}
