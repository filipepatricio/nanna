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

    final backgroundColor = messageState.value?.backgroundColor(context) ?? AppColors.snackBarInformative;
    final textColor = useMemoized(
      () => backgroundColor.computeLuminance() > 0.5 ? AppColors.stateTextPrimary : AppColors.stateTextSecondary,
      [backgroundColor],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        innerPadding,
        AppDimens.s,
        innerPadding,
        innerPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.modalRadius),
        boxShadow: cardShadows,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(bodyColor: textColor),
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
                child: messageState.value?.content(textColor),
              ),
              if (messageState.value != null) ...[
                buildSnackbarAction(messageState.value!, textColor),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSnackbarAction(SnackbarMessage message, Color textColor) {
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
              color: textColor,
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
  Color backgroundColor(BuildContext context) {
    switch (type) {
      case SnackbarMessageType.positive:
        return AppColors.snackBarPositive;
      case SnackbarMessageType.negative:
        return AppColors.snackBarNegative;
      case SnackbarMessageType.informative:
        return AppColors.snackBarInformative;
      case SnackbarMessageType.subscription:
        return AppColors.of(context).blackWhiteSecondary;
    }
  }

  Widget content(Color textColor) {
    return map(
      simple: (simple) {
        return AutoSizeText(
          simple.message,
          maxLines: 2,
          style: AppTypography.b2Regular.copyWith(color: textColor),
        );
      },
      custom: (custom) => custom.message,
    );
  }
}
