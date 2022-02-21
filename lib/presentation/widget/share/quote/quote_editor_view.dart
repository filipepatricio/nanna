import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

const _bottomSheetRadius = 10.0;
const _selectedBorderWidth = 2.0;
const _unselectedBorderWidth = 1.0;
const _separatorHeight = 1.0;

Future<void> showQuoteEditor(
  BuildContext context,
  MediaItemArticle article,
  String quote,
) {
  return showModalBottomSheet(
    context: context,
    constraints: BoxConstraints.loose(
      Size.fromHeight(
        MediaQuery.of(context).size.height,
      ),
    ),
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          _bottomSheetRadius,
        ),
      ),
    ),
    builder: (context) {
      return QuoteEditorView(
        article: article,
        quote: quote,
      );
    },
  );
}

class QuoteEditorView extends HookWidget {
  const QuoteEditorView({
    required this.article,
    required this.quote,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<QuoteEditorViewCubit>();
    final state = useCubitBuilder(cubit);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          _ColorSquareRow(
            cubit: cubit,
            selectedIndex: state.selectedIndex,
            variants: state.variants,
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            height: _separatorHeight,
            color: AppColors.appBarBackground.withOpacity(0.14),
          ),
          const SizedBox(height: AppDimens.l),
          _Button(
            svg: AppVectorGraphics.shareImage,
            text: tr(LocaleKeys.common_shareImage),
            onTap: () {
              AutoRouter.of(context).pop();
              cubit.shareImage(article, quote);
            },
          ),
          const SizedBox(height: AppDimens.m),
          _Button(
            svg: AppVectorGraphics.shareText,
            text: tr(LocaleKeys.common_shareText),
            onTap: () {
              AutoRouter.of(context).pop();
              Share.share(quote);
            },
          ),
        ],
      ),
    );
  }
}

class _ColorSquareRow extends StatelessWidget {
  const _ColorSquareRow({
    required this.cubit,
    required this.variants,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  final QuoteEditorViewCubit cubit;
  final List<QuoteVariantData> variants;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    var counter = 0;

    return Row(
      children: [
        const SizedBox(width: AppDimens.s),
        ...variants
            .map(
              (variant) {
                final index = counter++;
                return Expanded(
                  child: _ColorSquareOption(
                    color: variant.backgroundColor,
                    selected: index == selectedIndex,
                    selectionChanged: () => cubit.select(index),
                  ),
                );
              },
            )
            .expand(
              (element) => [
                element,
                const SizedBox(width: AppDimens.m),
              ],
            )
            .take(variants.length * 2 - 1)
            .toList(),
        const SizedBox(width: AppDimens.s),
      ],
    );
  }
}

class _ColorSquareOption extends StatelessWidget {
  const _ColorSquareOption({
    required this.color,
    required this.selected,
    required this.selectionChanged,
    Key? key,
  }) : super(key: key);

  final Color color;
  final bool selected;
  final VoidCallback selectionChanged;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: selectionChanged,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: _getBorder(),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                AppDimens.s,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Border _getBorder() {
    if (selected) {
      return Border.all(
        color: AppColors.blueSelected,
        width: _selectedBorderWidth,
      );
    }

    return Border.all(
      color: AppColors.greyDividerColor,
      width: _unselectedBorderWidth,
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

  final String svg;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
              width: AppDimens.xl,
              height: AppDimens.xl,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(width: AppDimens.s),
            Expanded(
              child: Text(
                text,
                style: AppTypography.h4Medium.copyWith(height: 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
