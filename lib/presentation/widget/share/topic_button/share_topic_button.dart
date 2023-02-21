import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_button/share_topic_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareTopicButton extends HookWidget {
  const ShareTopicButton({
    required this.topic,
    this.color,
    super.key,
  });

  final TopicPreview topic;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareTopicButtonCubit>();
    final state = useCubitBuilder(
      cubit,
      buildWhen: (state) => state != ShareTopicButtonState.copiedMessage,
    );
    final snackbarController = useSnackbarController();

    useCubitListener(cubit, (cubit, state, context) {
      if (state == ShareTopicButtonState.copiedMessage) {
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
            child: Center(
              child: ShareButton(
                iconColor: color,
                enabled: !state.isOffline,
                onTap: state.isOffline
                    ? (_) => snackbarController.showMessage(SnackbarMessage.offline(context))
                    : (selectedShareOption) => cubit.share(selectedShareOption, topic),
              ),
            ),
          ),
          if (state == ShareArticleButtonState.processing)
            const Positioned.fill(
              left: AppDimens.zero,
              right: AppDimens.zero,
              bottom: AppDimens.zero,
              top: AppDimens.zero,
              child: Loader(strokeWidth: 2.0),
            ),
        ],
      ),
    );
  }
}
