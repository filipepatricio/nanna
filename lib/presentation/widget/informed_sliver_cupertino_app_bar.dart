import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/cupertino_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';

class InformedSliverCupertinoAppBar extends StatelessWidget {
  const InformedSliverCupertinoAppBar({
    required this.title,
    this.leading,
    this.backgroundColor,
    this.textColor,
    this.actions,
    this.expanded,
    super.key,
  });

  final Widget? leading;
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Widget>? actions;
  final Widget? expanded;

  @override
  Widget build(BuildContext context) {
    final actions = this.actions;
    final expanded = this.expanded;

    return MultiSliver(
      children: [
        /// TODO: In next flutter release original CupertinoSliverNavigationBar will expose [alwaysShowMiddle] arg
        /// Then we can remove it
        /// For now we use it's copied implementation
        CupertinoSliverNavigationBar(
          transitionBetweenRoutes: false,
          backgroundColor: backgroundColor ?? AppColors.of(context).backgroundPrimary,
          border: null,
          padding: const EdgeInsetsDirectional.only(start: AppDimens.xs),
          leading: leading ?? BackTextButton(color: textColor ?? AppColors.of(context).textPrimary),
          middle: Text(
            title,
            style: AppTypography.h4Medium.copyWith(
              color: textColor ?? AppColors.of(context).textPrimary,
              fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
              height: 1.11,
            ),
          ),
          largeTitle: expanded == null
              ? _LargeTitle(title: title, textColor: textColor)
              : Row(
                  children: [
                    _LargeTitle(title: title, textColor: textColor),
                    Expanded(child: expanded),
                    const SizedBox(width: AppDimens.m),
                  ],
                ),
          trailing: actions == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
          alwaysShowMiddle: false,
        ),
        SliverToBoxAdapter(
          child: Container(
            height: AppDimens.s,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.of(context).shadowDividerColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LargeTitle extends StatelessWidget {
  const _LargeTitle({
    required this.title,
    required this.textColor,
  });

  final String title;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h0Medium.copyWith(
        color: textColor ?? AppColors.of(context).textPrimary,
        fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
        height: 1.1,
      ),
    );
  }
}
