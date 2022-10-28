import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_button/share_topic_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareTopicButton extends HookWidget {
  const ShareTopicButton({
    required this.topic,
    required this.snackbarController,
    this.iconColor,
    super.key,
  });

  final TopicPreview topic;
  final SnackbarController snackbarController;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareTopicButtonCubit>();
    final state = useCubitBuilder(
      cubit,
      buildWhen: (state) => state != ShareTopicButtonState.copiedMessage,
    );

    useCubitListener(cubit, (cubit, state, context) {
      if (state == ShareTopicButtonState.copiedMessage) {
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
          visible: state == ShareTopicButtonState.idle,
          child: Center(
            child: ShareButton(
              onTap: (selectedShareOption) => cubit.share(selectedShareOption, topic),
              iconColor: iconColor,
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
    );
  }
}
