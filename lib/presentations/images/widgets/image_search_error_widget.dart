import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/widgets/error/search_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/image_search_cubit.dart';


class ImageSearchErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final String query;

  const ImageSearchErrorWidget({
    super.key,
    required this.errorMessage,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return SearchErrorWidget(
      errorMessage: errorMessage,
      errorTitle: AppConstant.constErrorMessage,
      buttonText: AppConstant.tryAgain,
      onRetry: () => context.read<ImageSearchCubit>().searchImages(query),
      icon: Icons.image_not_supported,
    );
  }
}