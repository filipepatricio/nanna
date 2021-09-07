import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const listItemWidth = 155.0;
const listItemHeight = 260.0;

class ExclusiveArticleListItem extends StatelessWidget {
  final ArticleHeader articleHeader;

  const ExclusiveArticleListItem({
    required this.articleHeader,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => ArticlePage(article: articleHeader),
        useRootNavigator: true,
      ),
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(AppDimens.m),
        height: listItemHeight,
        width: listItemWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: ExclusiveLabel(),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Image.network(
                CloudinaryImageExtension.withPublicId(articleHeader.publisher.logo.publicId)
                    .transform()
                    .width((AppDimens.l * 4).round())
                    .fit()
                    .generate()!,
                width: AppDimens.l,
                height: AppDimens.l,
                fit: BoxFit.contain,
              ),
            ),
            InformedMarkdownBody(
              markdown: articleHeader.title,
              baseTextStyle: AppTypography.h5BoldSmall.copyWith(height: 1.4),
              maxLines: 4,
            ),
            const Spacer(),
            const ReadMoreLabel(),
          ],
        ),
      ),
    );
  }
}
