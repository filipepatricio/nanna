import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_option_item.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<ShareOption?> showShareOptions(BuildContext context) {
  return showModalBottomSheet<ShareOption?>(
    context: context,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          AppDimens.bottomSheetRadius,
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
                  GestureDetector(
                    onTap: () => AutoRouter.of(context).pop(),
                    child: const InformedSvg(
                      AppVectorGraphics.closeBackground,
                      colored: false,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            ...data.shareOptions
                .map(
                  (shareOption) => ShareOptionItem(
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
