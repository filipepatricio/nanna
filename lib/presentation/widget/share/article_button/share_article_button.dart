import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareArticleButton extends HookWidget {
  const ShareArticleButton({
    required this.article,
    this.color,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareArticleButtonCubit>();
    final state = useCubitBuilder(
      cubit,
      buildWhen: (state) => state != ShareArticleButtonState.showMessage,
    );
    final snackbarController = useSnackbarController();

    useCubitListener(cubit, (cubit, state, context) {
      if (state == ShareArticleButtonState.showMessage) {
        snackbarController.showMessage(
          SnackbarMessage.simple(
            message: context.l10n.common_linkCopied,
            type: SnackbarMessageType.success,
          ),
        );
      }
    });

    return Opacity(
      opacity: state.isOffline ? AppDimens.offlineIconOpacity : 1,
      child: Stack(
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: state.visible,
            child: ShareButton(
              iconColor: color,
              enabled: !state.isOffline,
              onTap: state.isOffline
                  ? (_) => snackbarController.showMessage(SnackbarMessage.offline(context))
                  : (shareOption) => cubit.share(shareOption, article),
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
      ),
    );
  }
}
