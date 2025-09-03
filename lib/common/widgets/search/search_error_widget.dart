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

    // Hata mesajını analiz et ve kullanıcı dostu hale getir
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
            'Bir hata oluştu',
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
            label: const Text('Tekrar Dene'),
          ),
        ],
      ).allPadding(16),
    );
  }

  String _getUserFriendlyMessage(String? errorMessage) {
    if (errorMessage == null) return 'Bilinmeyen bir hata oluştu';
    
    // API'den gelen teknik hata mesajlarını kullanıcı dostu hale getir
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