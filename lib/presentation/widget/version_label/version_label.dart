import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/version_label/version_label_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class VersionLabel extends HookWidget {
  const VersionLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<VersionLabelCubit>();
    final state = useCubitBuilder(
      cubit,
      buildWhen: (_) => true,
    );

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Text(
      'v$state',
      style: AppTypography.systemText.copyWith(
        color: AppColors.of(context).textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
