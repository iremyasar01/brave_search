import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/mixins/animation_mixin.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class WebViewLoadingAnimation extends StatefulWidget {
  final AnimationController controller;
  final Animation<double> fadeAnimation;

  const WebViewLoadingAnimation({
    super.key,
    required this.controller,
    required this.fadeAnimation,
  });

  @override
  State<WebViewLoadingAnimation> createState() => _WebViewLoadingAnimationState();
}

class _WebViewLoadingAnimationState extends State<WebViewLoadingAnimation> 
    with AnimationMixin {
      
  @override
  Widget build(BuildContext context) {
    return buildFadeLottieAnimation(
      assetPath: AssetConstants.searchAnim,
      controller: widget.controller,
      fadeAnimation: widget.fadeAnimation,
      text: AppConstant.loadingText,
      width: 100,
      height: 100,
    ).center();
  }
}