/*
import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/error/search_error_widget.dart';
import 'package:flutter/material.dart';

class WebSearchErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const WebSearchErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SearchErrorWidget(
      errorMessage: errorMessage,
      errorTitle: AppConstant.constErrorMessage,
      buttonText: AppConstant.tryAgain,
      onRetry: onRetry,
      icon: Icons.public_off,
    );
  }
}
*/