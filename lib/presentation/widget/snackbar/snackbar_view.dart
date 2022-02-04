import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _maxHeight = 96.0;

class SnackbarView extends HookWidget {
  const SnackbarView({
    this.message,
    Key? key,
  }) : super(key: key);

  final SnackbarMessage? message;

  @override
  Widget build(BuildContext context) {
    final textWidth = useMemoized(() => MediaQuery.of(context).size.width - 2 * AppDimens.xl - 2 * AppDimens.m);
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
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _maxHeight,
            maxWidth: textWidth,
          ),
          child: messageState.value?.content,
        ),
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
