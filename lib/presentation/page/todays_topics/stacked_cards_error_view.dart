import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/stacked_cards/stacked_cards_variant_a.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StackedCardsErrorView extends HookWidget {
  final Size size;
  final EdgeInsets padding;
  final VoidCallback? retryAction;

  const StackedCardsErrorView({
    required this.size,
    this.retryAction,
    this.padding = const EdgeInsets.only(
      bottom: AppDimens.c,
      top: AppDimens.xl,
    ),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _CardStack(
            size: size,
            child: GeneralErrorView(
              title: LocaleKeys.todaysTopics_oops.tr(),
              content: LocaleKeys.todaysTopics_tryAgainLater.tr(),
              svgPath: AppVectorGraphics.sadSun,
              retryCallback: retryAction,
            ),
          );
        },
      ),
    );
  }
}

class _CardStack extends StatelessWidget {
  const _CardStack({
    required this.size,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Size size;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StackedCardsVariantA(
      size: size,
      child: child,
    );
  }
}
