import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FixedAppBar extends HookWidget implements PreferredSizeWidget {
  const FixedAppBar({
    required this.scrollController,
    required this.title,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scrollOffset = useState(0.0);
    useEffect(() {
      final listener = () {
        scrollOffset.value = scrollController.offset;
      };
      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    final showCenterTitle = scrollOffset.value >= kToolbarHeight / 1.2;

    return AppBar(
      backgroundColor: AppColors.background,
      centerTitle: true,
      elevation: showCenterTitle ? 3 : 0,
      shadowColor: AppColors.shadowDarkColor,
      titleSpacing: 0,
      title: showCenterTitle
          ? Text(title,
              style: AppTypography.h4Bold.copyWith(
                  height: 2.25,
                  color: AppColors.textPrimary.withOpacity(
                    min(1, scrollOffset.value / 70),
                  )))
          : const SizedBox(),
      leading: IconButton(
        padding: const EdgeInsets.only(top: AppDimens.sl),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        iconSize: AppDimens.backArrowSize,
        color: AppColors.textPrimary,
        onPressed: () => AutoRouter.of(context).pop(),
      ),
    );
  }
}
