import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, networkState) {
        if (networkState is NetworkDisconnected) {
          return _buildDisconnectedBanner(context, colors);
        }
        
        if (networkState is NetworkConnected) {
          return _buildConnectedBanner(context, networkState, colors);
        }
        
        return _buildCheckingBanner(context, colors);
      },
    );
  }

  Widget _buildDisconnectedBanner(BuildContext context, AppColorsExtension colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade600,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'İnternet bağlantısı yok',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.read<NetworkCubit>().checkConnection(),
            child: const Icon(Icons.refresh, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedBanner(BuildContext context, NetworkConnected networkState, AppColorsExtension colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.green.shade600,
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            'Bağlı: ${networkState.connectivityTypes.map((e) => e.name).join(', ')}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckingBanner(BuildContext context, AppColorsExtension colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.orange.shade600,
      child: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
           SizedBox(width: 8),
           Text(
            'Bağlantı kontrol ediliyor...',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}