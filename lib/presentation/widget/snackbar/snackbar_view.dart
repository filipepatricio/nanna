import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _minHeight = 48.0;
const _maxHeight = 88.0;

class SnackbarView extends HookWidget {
  const SnackbarView({
    this.message,
    Key? key,
  }) : super(key: key);

  final SnackbarMessage? message;

  @override
  Widget build(BuildContext context) {
    final messageState = useState(message);

    useEffect(() {
      if (message != null) {
        messageState.value = message;
      }
    }, [message]);

    return Container(
      padding: const EdgeInsets.all(AppDimens.m),
      decoration: BoxDecoration(
        color: messageState.value?.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.s),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _minHeight,
          maxHeight: _maxHeight,
        ),
        child: messageState.value?.content,
      ),
    );
  }
}

extension on SnackbarMessage {
  Color get backgroundColor {
    switch (type) {
      case SnackbarMessageType.positive:
        return AppColors.darkGreyBackground;
      case SnackbarMessageType.negative:
        return AppColors.carrotRed;
    }
  }

  Widget get content {
    return map(
      simple: (simple) {
        return Text(
          simple.message,
          style: AppTypography.h4Normal.copyWith(color: AppColors.white),
        );
      },
      custom: (custom) {
        return custom.message;
      },
    );
  }
}
