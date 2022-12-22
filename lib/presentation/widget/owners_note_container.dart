import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';

class OwnersNoteContainer extends StatelessWidget {
  const OwnersNoteContainer({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: AppDimens.sl),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.brandAccent)),
      ),
      child: child,
    );
  }
}
