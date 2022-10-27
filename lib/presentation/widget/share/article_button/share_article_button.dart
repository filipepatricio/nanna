import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareArticleButton extends HookWidget {
  const ShareArticleButton({
    required this.article,
    required this.snackbarController,
    this.buttonBuilder,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final WidgetBuilder? buttonBuilder;
  final Color? backgroundColor;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareArticleButtonCubit>();
    final state = useCubitBuilder(cubit, buildWhen: (state) => true);

    useCubitListener(cubit, (cubit, state, context) {
      if (state == ShareArticleButtonState.showMessage) {
        snackbarController.showMessage(
          SnackbarMessage.simple(
            message: LocaleKeys.common_linkCopied.tr(),
            type: SnackbarMessageType.positive,
          ),
        );
      }
    });

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
            left: AppDimens.m,
            right: AppDimens.m,
            bottom: AppDimens.m,
            top: AppDimens.m,
            child: Loader(strokeWidth: 2.0),
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
        onTap: (shareOption) => cubit.share(shareOption, article),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          final shareOption = await showShareOptions(context);

          await cubit.share(shareOption, article);
        },
        child: builder(context),
      );
    }
  }
}
