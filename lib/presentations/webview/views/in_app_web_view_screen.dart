import 'package:brave_search/presentations/webview/widgets/web_view_app_bar.dart';
import 'package:brave_search/presentations/webview/widgets/web_view_body.dart';
import 'package:brave_search/presentations/webview/widgets/web_view_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/mixins/animation_mixin.dart';
import 'package:brave_search/presentations/webview/cubit/web_view_cubit.dart';



class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const InAppWebViewScreen({super.key, required this.url, required this.title});

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen>
    with SingleTickerProviderStateMixin, AnimationMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebViewCubit(widget.url),
      child: Scaffold(
        appBar: WebViewAppBar(
          title: widget.title,
          url: widget.url,
        ),
        body: WebViewBody(
          controller: _controller,
          fadeAnimation: _fadeAnimation,
        ),
        bottomNavigationBar: const WebViewBottomBar(),
      ),
    );
  }
}