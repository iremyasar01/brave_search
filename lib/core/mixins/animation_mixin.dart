import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

mixin AnimationMixin<T extends StatefulWidget> on State<T> {
  // Temel kontrollü Lottie animasyonu
  Widget buildControlledLottieAnimation({
    required String assetPath,
    required AnimationController controller,
    double width = 100,
    double height = 100,
    String text = '',
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    VoidCallback? onLoaded,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          controller: controller,
          repeat: repeat,
          onLoaded: (composition) {
            controller.duration = composition.duration;
            onLoaded?.call();
          },
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(text),
        ],
      ],
    );
  }

  // Fade efekti ile kontrollü animasyon
  Widget buildFadeLottieAnimation({
    required String assetPath,
    required AnimationController controller,
    required Animation<double> fadeAnimation,
    double width = 100,
    double height = 100,
    String text = '',
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    VoidCallback? onLoaded,
  }) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: buildControlledLottieAnimation(
        assetPath: assetPath,
        controller: controller,
        width: width,
        height: height,
        text: text,
        fit: fit,
        repeat: repeat,
        onLoaded: onLoaded,
      ),
    );
  }

  // Basit animasyon (controller gerektirmeyen)
  Widget buildSimpleLottieAnimation({
    required String assetPath,
    double width = 100,
    double height = 100,
    String text = '',
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          repeat: repeat,
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(text),
        ],
      ],
    );
  }
}