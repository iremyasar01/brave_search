import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class GenericSearchErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const GenericSearchErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    // Hata mesajını analiz et ve kullanıcı dostu hale getirme
    String userFriendlyMessage = _getUserFriendlyMessage(errorMessage);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 64,
          ).paddingBottom(16),
          Text(
            AppConstant.constErrorMessage,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ).paddingBottom(12),
          Text(
            userFriendlyMessage,
            style: TextStyle(
              color: colors.textHint,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ).paddingBottom(20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(AppConstant.tryAgain),
          ),
        ],
      ).allPadding(16),
    );
  }

  String _getUserFriendlyMessage(String? errorMessage) {
    if (errorMessage == null) return 'Bilinmeyen bir hata oluştu';
    

    if (errorMessage.contains('422')) {
      return 'Arama sınırına ulaşıldı. Lütfen daha spesifik bir arama yapın.';
    } else if (errorMessage.contains('network') || errorMessage.contains('connection')) {
      return 'İnternet bağlantınızı kontrol edin ve tekrar deneyin.';
    } else if (errorMessage.contains('timeout')) {
      return 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
    }
    
    return errorMessage;
  }
}