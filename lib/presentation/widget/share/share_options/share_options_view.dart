import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _bottomSheetRadius = 10.0;

Future<ShareOptions?> showShareOptions(BuildContext context) {
  return showModalBottomSheet<ShareOptions?>(
    context: context,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          _bottomSheetRadius,
        ),
      ),
    ),
    isScrollControlled: true,
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
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: state.maybeMap(
          orElse: () => [
            const Padding(
              padding: EdgeInsets.all(AppDimens.l),
              child: Loader(
                strokeWidth: 3.0,
                color: AppColors.limeGreen,
              ),
            ),
          ],
          idle: (data) => [
            Text(
              LocaleKeys.common_shareVia.tr(),
              style: AppTypography.h4ExtraBold,
            ),
            const SizedBox(height: AppDimens.s),
            ...data.shareOptions
                .where(
                  (shareOption) => shareOption != ShareOptions.copyLink && shareOption != ShareOptions.more,
                )
                .map(
                  (ShareOptions shareOption) => _Button(
                    svg: shareOption.getIcon(),
                    text: shareOption.getText(),
                    showIcon: shareOption == ShareOptions.copyLink || shareOption == ShareOptions.more,
                    onTap: () => AutoRouter.of(context).pop(shareOption),
                  ),
                )
                .toList(),
            const Divider(),
            ...data.shareOptions
                .where(
                  (shareOption) => shareOption == ShareOptions.copyLink || shareOption == ShareOptions.more,
                )
                .map(
                  (ShareOptions shareOption) => _Button(
                    svg: shareOption.getIcon(),
                    text: shareOption.getText(),
                    showIcon: shareOption == ShareOptions.copyLink || shareOption == ShareOptions.more,
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
    this.showIcon = false,
    Key? key,
  }) : super(key: key);

  final String? svg;
  final String text;
  final bool showIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
        child: SizedBox(
          height: AppDimens.xl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon && svg != null) ...[
                SvgPicture.asset(
                  svg!,
                  width: AppDimens.xl,
                  height: AppDimens.xl,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(width: AppDimens.s),
              ],
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.b2Medium.copyWith(height: 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
