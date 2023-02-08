import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _maxHeight = 120.0;

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

    final backgroundColor = messageState.value?.backgroundColor(context) ?? AppColors.snackBarInfo;
    final textColor = messageState.value?.textColor(context) ?? AppColors.stateTextPrimary;
    final subTextColor = messageState.value?.subTextColor(context) ?? AppColors.categoriesTextSecondary;

    final text = messageState.value?.buildText(textColor);
    final subText = messageState.value?.buildSubText(context, subTextColor);
    final action = messageState.value?.buildAction(textColor, dismissAction);

    if (text == null) return const SizedBox.shrink();

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final content = Column(
            crossAxisAlignment: action == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              text,
              if (subText != null) ...[
                const SizedBox(height: AppDimens.s),
                subText,
              ],
            ],
          );

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: _maxHeight,
              maxWidth: constraints.maxWidth - innerPadding,
            ),
            child: action == null
                ? content
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: content),
                      const SizedBox(width: AppDimens.m),
                      action,
                    ],
                  ),
          );
        },
      ),
    );
  }
}

extension on SnackbarMessage {
  Color backgroundColor(BuildContext context) {
    switch (type) {
      case SnackbarMessageType.success:
        return AppColors.snackBarSuccess;
      case SnackbarMessageType.info:
        return AppColors.snackBarInfo;
      case SnackbarMessageType.warning:
        return AppColors.snackBarWarning;
      case SnackbarMessageType.error:
        return AppColors.snackBarError;
      case SnackbarMessageType.subscription:
        return AppColors.of(context).blackWhiteSecondary;
    }
  }

  Color textColor(BuildContext context) {
    switch (type) {
      case SnackbarMessageType.error:
      case SnackbarMessageType.success:
        return AppColors.stateTextSecondary;
      case SnackbarMessageType.info:
      case SnackbarMessageType.warning:
        return AppColors.stateTextPrimary;
      case SnackbarMessageType.subscription:
        return AppColors.of(context).blackWhitePrimary;
    }
  }

  Color subTextColor(BuildContext context) {
    switch (type) {
      case SnackbarMessageType.error:
      case SnackbarMessageType.success:
        return AppColors.stateTextSecondary;
      case SnackbarMessageType.info:
      case SnackbarMessageType.warning:
        return AppColors.categoriesTextSecondary;
      case SnackbarMessageType.subscription:
        return AppColors.of(context).blackWhitePrimary;
    }
  }

  Widget buildText(Color color) {
    return AutoSizeText(
      message,
      maxLines: 2,
      textAlign: action != null ? TextAlign.start : TextAlign.center,
      style: AppTypography.b2Medium.w550.copyWith(
        color: color,
      ),
    );
  }

  Widget? buildSubText(BuildContext context, Color color) {
    if (subMessage == null) return null;

    return AutoSizeText(
      subMessage!,
      maxLines: 2,
      textAlign: action != null ? TextAlign.start : TextAlign.center,
      style: AppTypography.sansTextSmallLausanne.copyWith(
        color: color,
      ),
    );
  }

  Widget? buildAction(Color textColor, VoidCallback? dismissAction) {
    if (action == null) return null;

    return GestureDetector(
      onTap: () {
        dismissAction?.call();
        action!.callback();
      },
      child: AutoSizeText(
        action!.label,
        style: AppTypography.b2Medium.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
