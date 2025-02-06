import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieView extends StatelessWidget {
  final String lottiePath;
  final bool isAsset;
  final Color? backgroundColor;

  const LottieView(
      {super.key,
      required this.lottiePath,
      this.isAsset = true,
      this.backgroundColor = const Color(0xFF2746C7)});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: isAsset
            ? Lottie.asset(
                lottiePath,
                width: 115,
                height: 115,
                fit: BoxFit.contain,
              )
            : Lottie.network(
                lottiePath,
                width: 115,
                height: 115,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
