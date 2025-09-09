part of 'web_view_cubit.dart';

class WebViewState {
  final bool isLoading;
  final bool canGoBack;
  final bool canGoForward;

  WebViewState({
    required this.isLoading,
    this.canGoBack = false,
    this.canGoForward = false,
  });

  WebViewState copyWith({
    bool? isLoading,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return WebViewState(
      isLoading: isLoading ?? this.isLoading,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is WebViewState &&
        other.isLoading == isLoading &&
        other.canGoBack == canGoBack &&
        other.canGoForward == canGoForward;
  }

  @override
  int get hashCode => isLoading.hashCode ^ canGoBack.hashCode ^ canGoForward.hashCode;
}