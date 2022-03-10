import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareArticleButton extends HookWidget {
  final MediaItemArticle article;
  final WidgetBuilder? buttonBuilder;
  final Color? backgroundColor;

  const ShareArticleButton({
    required this.article,
    this.buttonBuilder,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareArticleButtonCubit>();
    final state = useCubitBuilder(cubit, buildWhen: (state) => true);

    return Stack(
      children: [
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: state == ShareArticleButtonState.idle,
          child: _Button(
            cubit: cubit,
            article: article,
            buttonBuilder: buttonBuilder,
            backgroundColor: backgroundColor,
          ),
        ),
        if (state == ShareArticleButtonState.processing)
          const Positioned.fill(
            left: AppDimens.xs,
            right: AppDimens.xs,
            bottom: AppDimens.xs,
            top: AppDimens.xs,
            child: Loader(
              strokeWidth: 3.0,
              color: AppColors.limeGreen,
            ),
          ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.cubit,
    required this.article,
    required this.buttonBuilder,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final WidgetBuilder? buttonBuilder;
  final Color? backgroundColor;
  final ShareArticleButtonCubit cubit;

  @override
  Widget build(BuildContext context) {
    final builder = buttonBuilder;

    if (builder == null) {
      return ShareButton(
        backgroundColor: backgroundColor,
        onTap: () => cubit.share(article),
      );
    } else {
      return GestureDetector(
        onTap: () => cubit.share(article),
        child: builder(context),
      );
    }
  }
}
