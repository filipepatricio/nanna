import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({
    required this.child,
    this.snackbarController,
    this.onClose,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final SnackbarController? snackbarController;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onClose?.call();
        return true;
      },
      child: SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.m)),
          child: Scaffold(
            body: SnackbarParentView(
              controller: snackbarController,
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimens.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.l),
                      child: IconButton(
                        icon: const InformedSvg(AppVectorGraphics.close),
                        color: Theme.of(context).iconTheme.color,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        onPressed: context.popRoute,
                      ),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
