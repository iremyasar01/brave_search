import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/core/network/views/no_internet_screen.dart';
import 'package:brave_search/presentations/browser/widgets/browser_body.dart';
import 'package:brave_search/presentations/browser/widgets/browser_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkAwareScaffold extends StatelessWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> headerVisibilityNotifier;
  final ValueNotifier<bool> paginationVisibilityNotifier;

  const NetworkAwareScaffold({
    super.key,
    required this.scrollController,
    required this.headerVisibilityNotifier,
    required this.paginationVisibilityNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, networkState) {
        if (networkState is NetworkDisconnected) {
          return const NoInternetScreen();
        }
        
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: BrowserBody(
              scrollController: scrollController,
              headerVisibilityNotifier: headerVisibilityNotifier,
              paginationVisibilityNotifier: paginationVisibilityNotifier,
            ),
          ),
          bottomNavigationBar: const BrowserBottomNav(),
        );
      },
    );
  }
}