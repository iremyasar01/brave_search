import 'package:brave_search/presentations/webview/cubit/web_view_cubit.dart';
import 'package:brave_search/presentations/webview/widgets/web_view_loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewBody extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fadeAnimation;

  const WebViewBody({
    super.key,
    required this.controller,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WebViewCubit, WebViewState>(
      listener: (context, state) {
        // Animasyonu state değişikliklerine göre kontrol et
        if (state.isLoading) {
          controller.repeat(reverse: true);
        } else {
          controller.stop();
          controller.reset();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            WebViewWidget(
              controller: context.read<WebViewCubit>().controller,
            ),
            if (state.isLoading)
              WebViewLoadingAnimation(
                controller: controller,
                fadeAnimation: fadeAnimation,
              ),
          ],
        );
      },
    );
  }
}