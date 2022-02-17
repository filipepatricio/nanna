import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

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
          10.0,
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

class QuoteEditorView extends StatelessWidget {
  const QuoteEditorView({
    required this.article,
    required this.quote,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          const _ColorSquareRow(),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            height: 1.0,
            color: AppColors.appBarBackground.withOpacity(0.14),
          ),
          const SizedBox(height: AppDimens.l),
          _Button(
            svg: AppVectorGraphics.shareImage,
            text: tr(LocaleKeys.common_shareImage),
            onTap: () {},
          ),
          const SizedBox(height: AppDimens.m),
          _Button(
            svg: AppVectorGraphics.shareText,
            text: tr(LocaleKeys.common_shareText),
            onTap: () => Share.share(quote),
          ),
        ],
      ),
    );
  }
}

class _ColorSquareRow extends StatelessWidget {
  const _ColorSquareRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppDimens.s),
        Expanded(
          child: _ColorSquareOption(
            color: AppColors.lightGrey,
            selected: false,
            selectionChanged: () {},
          ),
        ),
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: _ColorSquareOption(
            color: AppColors.rose,
            selected: false,
            selectionChanged: () {},
          ),
        ),
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: _ColorSquareOption(
            color: AppColors.pastelGreen,
            selected: true,
            selectionChanged: () {},
          ),
        ),
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: _ColorSquareOption(
            color: AppColors.peach10,
            selected: false,
            selectionChanged: () {},
          ),
        ),
        const SizedBox(width: AppDimens.m),
        Expanded(
          child: _ColorSquareOption(
            color: AppColors.darkGreyBackground,
            selected: false,
            selectionChanged: () {},
          ),
        ),
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
        width: 2.0,
      );
    }

    return Border.all(
      color: AppColors.greyDividerColor,
      width: 1.0,
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
