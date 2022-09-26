import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({
    required this.child,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SnackbarParentView(
            controller: snackbarController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.l, AppDimens.l, AppDimens.l, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(AppVectorGraphics.close),
                    color: AppColors.black,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    onPressed: context.popRoute,
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
