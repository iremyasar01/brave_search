import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
import 'package:brave_search/core/mixins/animation_mixin.dart';
import 'package:brave_search/core/services/web_view_service.dart';
import 'package:brave_search/presentations/webview/cubit/web_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const InAppWebViewScreen({super.key, required this.url, required this.title});

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen>
    with SingleTickerProviderStateMixin, AnimationMixin {
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewCubit(widget.url),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => WebViewService.launchUrlExternal(widget.url),
            ),
          ],
        ),
        body: BlocConsumer<WebViewCubit, WebViewState>(
          listener: (context, state) {
            // Animasyonu state değişikliklerine göre kontrol et
            if (state.isLoading) {
              _controller.repeat(reverse: true);
            } else {
              _controller.stop();
              _controller.reset();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                WebViewWidget(controller: context.read<WebViewCubit>().controller),
                if (state.isLoading)
                  buildFadeLottieAnimation(
                    assetPath: AssetConstants.searchAnim,
                    controller: _controller,
                    fadeAnimation: _fadeAnimation,
                    text: AppConstant.loadingText,
                    width: 100,
                    height: 100,
                  ).center(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<WebViewCubit, WebViewState>(
          builder: (context, state) {
            return BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                    onPressed: state.canGoBack ? () => context.read<WebViewCubit>().goBack() : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: state.canGoBack ? null : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: state.canGoForward ? () => context.read<WebViewCubit>().goForward() : null,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: state.canGoForward ? null : Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.read<WebViewCubit>().reload(),
                    icon: const Icon(Icons.refresh),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}