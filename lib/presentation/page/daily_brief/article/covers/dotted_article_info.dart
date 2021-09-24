import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class DottedArticleInfo extends StatelessWidget {
  final ArticleHeader article;
  final Color? textColor;

  const DottedArticleInfo({
    required this.article,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image.network(
            CloudinaryImageExtension.withPublicId(article.publisher.lightLogo.publicId)
                .transform()
                .width(DimensionUtil.getPhysicalPixelsAsInt(AppDimens.l, context))
                .fit()
                .generate()!,
            width: AppDimens.l,
            height: AppDimens.l,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: AppDimens.s),
        Text(
          article.publisher.name,
          style: AppTypography.metadata1Regular.copyWith(color: textColor),
        ),
        Text(
          ' · ',
          style: AppTypography.metadata1Regular.copyWith(color: textColor),
        ),
        Text(
          article.publicationDate,
          style: AppTypography.metadata1Regular.copyWith(color: textColor),
        ),
        Text(
          ' · ',
          style: AppTypography.metadata1Regular.copyWith(color: textColor),
        ),
        Text(
          LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
          style: AppTypography.metadata1Regular.copyWith(color: textColor),
        ),
      ],
    );
  }
}
