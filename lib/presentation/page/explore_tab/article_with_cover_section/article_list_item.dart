import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const listItemWidth = 155.0;
const listItemHeight = 260.0;

class ArticleListItem extends HookWidget {
  final ArticleHeader articleHeader;
  final Color themeColor;
  final Color cardColor;
  final double? height;
  final double? width;

  const ArticleListItem({
    required this.articleHeader,
    required this.themeColor,
    this.cardColor = AppColors.background,
    this.height = listItemHeight,
    this.width = listItemWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = articleHeader.image?.publicId;

    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(
        ArticlePageRoute(
          pageData: ArticlePageData.singleArticle(
            article: articleHeader,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: imageId == null
              ? null
              : DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: NetworkImage(
                    cloudinaryProvider.withPublicId(imageId).url,
                  ),
                ),
        ),
        child: Container(
          color: imageId == null ? cardColor : AppColors.black.withOpacity(0.6),
          padding: const EdgeInsets.all(AppDimens.m),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: articleHeader.type == ArticleType.premium
                    ? const ExclusiveLabel()
                    : ArticleLabel.opinion(backgroundColor: themeColor),
              ),
              const Spacer(),
              PublisherLogo.light(publisher: articleHeader.publisher),
              InformedMarkdownBody(
                markdown: articleHeader.title,
                baseTextStyle: AppTypography.h5BoldSmall.copyWith(
                  height: 1.4,
                  color: imageId == null ? AppColors.textPrimary : AppColors.white,
                ),
                maxLines: 4,
              ),
              const Spacer(),
              ReadMoreLabel(
                foregroundColor: imageId == null ? AppColors.textPrimary : AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
