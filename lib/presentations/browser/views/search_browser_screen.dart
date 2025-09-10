import 'package:brave_search/presentations/browser/widgets/network_aware_scaffold.dart';
import 'package:brave_search/presentations/images/cubit/image_search_cubit.dart';
import 'package:brave_search/presentations/news/cubit/news_search_cubit.dart';
import 'package:brave_search/presentations/videos/cubit/video_search_cubit.dart';
import 'package:brave_search/presentations/web/cubit/web_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:brave_search/core/mixins/scroll_visibility_mixin.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/presentations/browser/cubit/browser_cubit.dart';

class SearchBrowserScreen extends StatefulWidget {
  const SearchBrowserScreen({super.key});

  @override
  State<SearchBrowserScreen> createState() => _SearchBrowserScreenState();
}

class _SearchBrowserScreenState extends State<SearchBrowserScreen>
    with ScrollVisibilityMixin {
  late BrowserCubit _browserCubit;
  late ScrollController _scrollController;
  late WebSearchCubit _webSearchCubit;
  late ImageSearchCubit _imageSearchCubit;
  late VideoSearchCubit _videoSearchCubit;
  late NewsSearchCubit _newsSearchCubit;


  @override
  void initState() {
    super.initState();

    _browserCubit = GetIt.instance<BrowserCubit>();
      _webSearchCubit = GetIt.instance<WebSearchCubit>();
    _imageSearchCubit = GetIt.instance<ImageSearchCubit>();
    _videoSearchCubit = GetIt.instance<VideoSearchCubit>();
    _newsSearchCubit = GetIt.instance<NewsSearchCubit>();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    disposeVisibilityNotifiers();
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    updateVisibilityBasedOnScroll(scrollPosition, maxScroll);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _browserCubit),
        BlocProvider.value(value: GetIt.instance<NetworkCubit>()),

      BlocProvider.value(value: _webSearchCubit),
        BlocProvider.value(value: _imageSearchCubit),
        BlocProvider.value(value: _videoSearchCubit),
        BlocProvider.value(value: _newsSearchCubit),
      ],
      child: NetworkAwareScaffold(
        scrollController: _scrollController,
        headerVisibilityNotifier: headerVisibilityNotifier,
        paginationVisibilityNotifier: paginationVisibilityNotifier,
      ),
    );
  }
}
