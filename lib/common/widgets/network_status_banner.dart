import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;
    
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        // Internet geri geldiğinde SnackBar göster
        if (state is NetworkConnected) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.wifi, color: theme.colorScheme.onPrimary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'İnternet bağlantısı sağlandı',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
              backgroundColor: colors.accent,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<NetworkCubit, NetworkState>(
        builder: (context, networkState) {
          // Sadece disconnect durumunda banner göster
          if (networkState is NetworkDisconnected) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.red.shade600,
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: theme.colorScheme.onError, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'İnternet bağlantısı yok',
                      style: TextStyle(
                        color: theme.colorScheme.onError,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.read<NetworkCubit>().checkConnection(),
                    child: Icon(
                      Icons.refresh, 
                      color: theme.colorScheme.onError, 
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Diğer durumlarda hiçbir şey gösterme
          return const SizedBox.shrink();
        },
      ),
    );
  }
}