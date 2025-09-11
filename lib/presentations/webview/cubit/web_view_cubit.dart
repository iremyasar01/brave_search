import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'web_view_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit(String url) : super(WebViewState(isLoading: true)) {
    _initializeWebViewController(url);
  }

  late final WebViewController controller;

  void _initializeWebViewController(String url) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            emit(state.copyWith(isLoading: true));
          },
          onPageFinished: (String url) async {
            final canGoBack = await controller.canGoBack();
            final canGoForward = await controller.canGoForward();
            emit(state.copyWith(
              isLoading: false, 
              canGoBack: canGoBack,
              canGoForward: canGoForward,
            ));
          },
          onWebResourceError: (error) {
            // Hata durumunda da loading'i durdur
            emit(state.copyWith(isLoading: false));
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> goBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    }
  }

  Future<void> goForward() async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    }
  }

  void reload() {
    controller.reload();
  }
}