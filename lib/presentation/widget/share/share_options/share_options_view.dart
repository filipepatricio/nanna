import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _bottomSheetRadius = 10.0;

Future<ShareOption?> showShareOptions(BuildContext context) {
  return showModalBottomSheet<ShareOption?>(
    context: context,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          _bottomSheetRadius,
        ),
      ),
    ),
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      return const _ShareOptionsView();
    },
  );
}

class _ShareOptionsView extends HookWidget {
  const _ShareOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareOptionsCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: state.maybeMap(
          orElse: () => [
            const Padding(
              padding: EdgeInsets.all(AppDimens.l),
              child: Loader(strokeWidth: 3.0),
            ),
          ],
          idle: (data) => [
            Padding(
              padding: const EdgeInsets.all(AppDimens.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.common_shareVia.tr(),
                    style: AppTypography.b2Medium,
                  ),
                  const Spacer(),
                  SvgPicture.asset(AppVectorGraphics.closeBackground),
                ],
              ),
            ),
            const Divider(height: 0),
            ...data.shareOptions
                .map(
                  (shareOption) => _Button(
                    svg: shareOption.getIcon(),
                    text: shareOption.getText(),
                    onTap: () => AutoRouter.of(context).pop(shareOption),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.svg,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String? svg;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final svg = this.svg;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTypography.b2Regular,
              ),
            ),
            if (svg != null) ...[
              SvgPicture.asset(
                svg,
                width: AppDimens.l,
                height: AppDimens.l,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
