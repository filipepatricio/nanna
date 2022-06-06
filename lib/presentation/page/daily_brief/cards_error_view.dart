import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardsErrorView extends HookWidget {
  final Size size;
  final EdgeInsets padding;
  final VoidCallback? retryAction;

  const CardsErrorView({
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
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.m),
              color: AppColors.darkLinen,
            ),
            height: size.height,
            width: size.width,
            child: GeneralErrorView(
              title: LocaleKeys.dailyBrief_oops.tr(),
              content: LocaleKeys.dailyBrief_tryAgainLater.tr(),
              svgPath: AppVectorGraphics.sadSun,
              retryCallback: retryAction,
            ),
          );
        },
      ),
    );
  }
}
