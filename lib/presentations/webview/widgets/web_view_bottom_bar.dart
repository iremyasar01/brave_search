import 'package:brave_search/presentations/webview/cubit/web_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebViewBottomBar extends StatelessWidget {
  const WebViewBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebViewCubit, WebViewState>(
      builder: (context, state) {
        return BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: state.canGoBack
                    ? () => context.read<WebViewCubit>().goBack()
                    : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: state.canGoBack ? null : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: state.canGoForward
                    ? () => context.read<WebViewCubit>().goForward()
                    : null,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: state.canGoForward ? null : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () => context.read<WebViewCubit>().reload(),
                icon: const Icon(Icons.refresh),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}