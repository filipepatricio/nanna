import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/widgets.dart';

class DottedArticleInfo extends StatelessWidget {
  final MediaItemArticle article;
  final bool isLight;
  final bool showPublisher;
  final bool showLogo;
  final bool showDate;
  final bool fullDate;
  final bool showReadTime;
  final TextStyle textStyle;
  final Color? color;

  const DottedArticleInfo({
    required this.article,
    required this.isLight,
    this.showPublisher = true,
    this.showLogo = true,
    this.showDate = true,
    this.fullDate = false,
    this.showReadTime = true,
    this.textStyle = AppTypography.metadata1Regular,
    this.color,
    Key? key,
  })  : assert(showPublisher || showDate || showReadTime, 'Select at least one of the sections to show'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? (isLight ? AppColors.white : AppColors.black);
    final publicationDate = article.publicationDate;
    final timeToRead = article.timeToRead;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showPublisher) ...[
          if (showLogo) ...[
            if (isLight)
              PublisherLogo.light(publisher: article.publisher)
            else
              PublisherLogo.dark(publisher: article.publisher),
          ],
          Text(
            article.publisher.name,
            style: textStyle.copyWith(color: mainColor, height: 1),
          ),
        ],
        if (showDate && publicationDate != null)
          Text(
            '${showPublisher ? ' · ' : ''}${fullDate ? DateFormatUtil.formatFullMonthNameDayYear(publicationDate) : DateFormatUtil.formatShortMonthNameDay(publicationDate)}',
            style: textStyle.copyWith(color: mainColor, height: 1),
          ),
        if (showReadTime && timeToRead != null)
          Text(
            '${showPublisher || showDate ? ' · ' : ''}${LocaleKeys.article_readMinutes.tr(
              args: [timeToRead.toString()],
            )}',
            style: textStyle.copyWith(color: mainColor, height: 1),
          ),
      ],
    );
  }
}