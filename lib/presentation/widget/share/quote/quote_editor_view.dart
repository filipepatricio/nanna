import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_editor_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    backgroundColor: AppColors.of(context).backgroundPrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          AppDimens.bottomSheetRadius,
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
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.shareQuote_title.tr(),
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
          ShareOptionItem(
            svg: AppVectorGraphics.image,
            text: tr(LocaleKeys.shareQuote_as_image),
            onTap: () {
              AutoRouter.of(context).pop();
              cubit.shareSticker(
                article,
                quote,
              );
            },
          ),
          ShareOptionItem(
            svg: AppVectorGraphics.text,
            text: tr(LocaleKeys.shareQuote_as_text),
            onTap: () {
              AutoRouter.of(context).pop();
              cubit.shareText(article, quote);
            },
          ),
          if (state.isInstagramAvailable) ...[
            ShareOptionItem(
              svg: AppVectorGraphics.igStory,
              text: tr(LocaleKeys.shareQuote_as_igStory),
              onTap: () {
                AutoRouter.of(context).pop();
                cubit.shareStory(article, quote);
              },
            ),
          ],
        ],
      ),
    );
  }
}
