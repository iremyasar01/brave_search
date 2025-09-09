import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
import 'package:brave_search/core/services/web_view_service.dart';
import 'package:brave_search/presentations/webview/cubit/web_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  const InAppWebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewCubit(url),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () => WebViewService.launchUrlExternal(url),
            ),
          ],
        ),
        body: BlocConsumer<WebViewCubit, WebViewState>(
          listener: (context, state) {
            // State değişikliklerini dinlemek için
          },
          builder: (context, state) {
            return Stack(
              children: [
                WebViewWidget(controller: context.read<WebViewCubit>().controller),
                if (state.isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          AssetConstants.searchAnim, 
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(AppConstant.loadingText),
                      ],
                    ),
                  ),
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
