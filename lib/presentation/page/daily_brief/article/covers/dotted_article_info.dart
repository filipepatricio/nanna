import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DottedArticleInfo extends HookWidget {
  final ArticleHeader article;
  final Color? textColor;

  const DottedArticleInfo({
    required this.article,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image.network(
            cloudinaryProvider
                .withPublicId(article.publisher.lightLogo.publicId)
                .transform()
                .width(DimensionUtil.getPhysicalPixelsAsInt(AppDimens.l, context))
                .fit()
                .generateNotNull(),
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
          DateFormatUtil.formatShortMonthNameDay(article.publicationDate),
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
