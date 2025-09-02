import 'package:brave_search/common/widgets/tab_navigation_bar.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/browser_cubit.dart';
import '../cubit/browser_state.dart';
import '../widgets/browser_header.dart';
import '../widgets/empty_browser_state.dart';
import '../widgets/search_results_view.dart';
import '../../web/cubit/web_search_cubit.dart';
import '../../images/cubit/image_search_cubit.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class SearchBrowserScreen extends StatefulWidget {
  const SearchBrowserScreen({super.key});

  @override
  State<SearchBrowserScreen> createState() => _SearchBrowserScreenState();
}

class _SearchBrowserScreenState extends State<SearchBrowserScreen> {
  late BrowserCubit _browserCubit;
  late WebSearchCubit _webSearchCubit;
  late ImageSearchCubit _imageSearchCubit;
  late VideoSearchCubit _videoSearchCubit;
  late NewsSearchCubit _newsSearchCubit;

  @override
  void initState() {
    super.initState();

    // GetIt'ten instance'ları al
    _browserCubit = GetIt.instance<BrowserCubit>();
    _webSearchCubit = GetIt.instance<WebSearchCubit>();
    _imageSearchCubit = GetIt.instance<ImageSearchCubit>();
    _videoSearchCubit = GetIt.instance<VideoSearchCubit>();
    _newsSearchCubit = GetIt.instance<NewsSearchCubit>();

    // İlk sekmeyi oluştur
    if (_browserCubit.state.tabs.isEmpty) {
      _browserCubit.addTab();
    }
  }

  void _onTabTapped(int index) {
    _browserCubit.switchTab(index);
  }

  void _addNewTab() {
    _browserCubit.addTab();
  }

  // Bağlantı tipine göre ikon belirleme
  IconData _getConnectionIcon(List<ConnectivityResult> connectivityTypes) {
    if (connectivityTypes.contains(ConnectivityResult.wifi)) {
      return Icons.wifi;
    } else if (connectivityTypes.contains(ConnectivityResult.mobile)) {
      return Icons.network_cell;
    } else if (connectivityTypes.contains(ConnectivityResult.ethernet)) {
      return Icons.settings_ethernet;
    } else {
      return Icons.signal_wifi_off;
    }
  }

  // Bağlantı tipine göre metin belirleme
  String _getConnectionText(List<ConnectivityResult> connectivityTypes) {
    if (connectivityTypes.contains(ConnectivityResult.wifi)) {
      return "Wi-Fi bağlantısı var";
    } else if (connectivityTypes.contains(ConnectivityResult.mobile)) {
      return "Mobil veri bağlantısı var";
    } else if (connectivityTypes.contains(ConnectivityResult.ethernet)) {
      return "Ethernet bağlantısı var";
    } else {
      return "İnternet bağlantısı yok";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _browserCubit),
        BlocProvider.value(value: _webSearchCubit),
        BlocProvider.value(value: _imageSearchCubit),
        BlocProvider.value(value: _videoSearchCubit),
        BlocProvider.value(value: _newsSearchCubit),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // İnternet bağlantı durumu banner'ı
              BlocBuilder<NetworkCubit, NetworkState>(
                builder: (context, networkState) {
                  if (networkState is NetworkConnected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.green.withOpacity(0.9),
                      child: Row(
                        children: [
                          Icon(_getConnectionIcon(networkState.connectivityTypes), 
                               color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getConnectionText(networkState.connectivityTypes),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.close, color: Colors.white, size: 16),
                        ],
                      ),
                    );
                  } else if (networkState is NetworkDisconnected) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.red.withOpacity(0.9),
                      child:const Row(
                        children: [
                           Icon(Icons.signal_wifi_off, color: Colors.white, size: 16),
                           SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.close, color: Colors.white, size: 16),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              
              // Browser Header with search bar
              const BrowserHeader(),
              Expanded(
                child: BlocBuilder<BrowserCubit, BrowserState>(
                  builder: (context, browserState) {
                    if (browserState.tabs.isEmpty) {
                      return const EmptyBrowserState();
                    }
                    return const SearchResultsView();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<BrowserCubit, BrowserState>(
          builder: (context, browserState) {
            return TabNavigationBar(
              selectedIndex: browserState.activeTabIndex,
              onTabTapped: _onTabTapped,
              onAddTab: _addNewTab,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // GetIt instance'ları dispose etme - singleton'lar
    super.dispose();
  }
}