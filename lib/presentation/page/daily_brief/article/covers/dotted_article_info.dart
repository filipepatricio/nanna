import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class DottedArticleInfo extends StatelessWidget {
  final MediaItemArticle article;
  final bool isLight;

  const DottedArticleInfo({
    required this.article,
    required this.isLight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = isLight ? AppColors.white : AppColors.black;
    final publicationDate = article.publicationDate;
    return Row(
      children: [
        if (isLight)
          PublisherLogo.light(publisher: article.publisher)
        else
          PublisherLogo.dark(publisher: article.publisher),
        Text(
          '${article.publisher.name} · ',
          style: AppTypography.metadata1Regular.copyWith(color: mainColor),
        ),
        if (publicationDate != null)
          Text(
            '${DateFormatUtil.formatShortMonthNameDay(publicationDate)} · ',
            style: AppTypography.metadata1Regular.copyWith(color: mainColor),
          ),
        Text(
          LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
          style: AppTypography.metadata1Regular.copyWith(color: mainColor),
        ),
      ],
    );
  }
}
