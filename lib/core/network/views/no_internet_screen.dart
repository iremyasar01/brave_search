import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: colors.iconSecondary),
            const SizedBox(height: 24),
            Text(
              NetworkStrings.noInternet,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.textHint,
              ),
            ).paddingBottom(12),
            Text(
              NetworkStrings.offlineMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colors.textHint,
                height: 1.5,
              ),
            ).paddingBottom(32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NetworkCubit>().checkConnection();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(NetworkStrings.checkingConnection),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text(AppConstant.tryAgain),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ).allPadding(24),
      ),
    );
  }
}