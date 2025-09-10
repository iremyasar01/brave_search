import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/presentations/history/cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:brave_search/core/extensions/widget_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/common/constant/app_constant.dart';

class MyHistoryError extends StatelessWidget {
  final String message;

  const MyHistoryError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
          ).paddingBottom(16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.error ?? Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<HistoryCubit>().loadHistory(),
            child: const Text(AppConstant.tryAgain),
          ),
        ],
      ),
    );
  }
}