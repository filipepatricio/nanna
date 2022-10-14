import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _maxHeight = 96.0;

class SnackbarView extends HookWidget {
  const SnackbarView({
    this.message,
    this.dismissAction,
    Key? key,
  }) : super(key: key);

  final SnackbarMessage? message;
  final VoidCallback? dismissAction;

  @override
  Widget build(BuildContext context) {
    const innerPadding = AppDimens.m;
    final messageState = useState(message);

    useEffect(
      () {
        if (message != null) {
          messageState.value = message;
        }
      },
      [message],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        innerPadding,
        AppDimens.s,
        innerPadding,
        innerPadding,
      ),
      decoration: BoxDecoration(
        color: messageState.value?.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.s),
        ),
        boxShadow: cardShadows,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _maxHeight,
                maxWidth: constraints.maxWidth - 2 * innerPadding,
              ),
              child: messageState.value?.content,
            ),
            if (messageState.value != null) ...[
              buildSnackbarAction(messageState.value!),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildSnackbarAction(SnackbarMessage message) {
    return message.map(
      simple: (message) {
        if (message.action == null) {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: () {
            dismissAction?.call();
            message.action!.callback();
          },
          child: Text(
            message.action!.label,
            style: AppTypography.h4ExtraBold.copyWith(
              color: AppColors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      },
      custom: (message) => const SizedBox.shrink(),
    );
  }
}

extension on SnackbarMessage {
  Color get backgroundColor {
    switch (type) {
      case SnackbarMessageType.positive:
        return AppColors.snackBarPositive;
      case SnackbarMessageType.negative:
        return AppColors.snackBarNegative;
      case SnackbarMessageType.informative:
        return AppColors.snackBarInformative;
    }
  }

  Widget get content {
    return map(
      simple: (simple) {
        return AutoSizeText(
          simple.message,
          maxLines: 2,
          style: AppTypography.b2Regular.copyWith(color: AppColors.white),
        );
      },
      custom: (custom) {
        return custom.message;
      },
    );
  }
}
