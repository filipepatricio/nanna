import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/widgets.dart';

class DottedArticleInfo extends StatelessWidget {
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
    this.publisherMaxLines = 1,
    this.centerContent = false,
    Key? key,
  })  : assert(showPublisher || showDate || showReadTime, 'Select at least one of the sections to show'),
        super(key: key);

  final MediaItemArticle article;
  final bool isLight;
  final bool showPublisher;
  final bool showLogo;
  final bool showDate;
  final bool fullDate;
  final bool showReadTime;
  final TextStyle textStyle;
  final Color? color;
  final int publisherMaxLines;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? (isLight ? AppColors.white : AppColors.black);
    final timeToRead = article.timeToRead;
    final publicationDate = article.publicationDate;

    final canShowReadTime = showReadTime && timeToRead != null;
    final canShowDate = showDate && publicationDate != null;

    return Wrap(
      runAlignment: WrapAlignment.center,
      alignment: centerContent ? WrapAlignment.center : WrapAlignment.start,
      children: [
        if (showPublisher) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: centerContent ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLogo) ...[
                if (isLight)
                  PublisherLogo.light(publisher: article.publisher)
                else
                  PublisherLogo.dark(publisher: article.publisher),
              ],
              Flexible(
                child: Text(
                  article.publisher.name,
                  style: textStyle.copyWith(color: mainColor),
                  maxLines: publisherMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (canShowDate)
          Text(
            '${showPublisher ? ' · ' : ''}${fullDate ? DateFormatUtil.formatFullMonthNameDayYear(publicationDate) : DateFormatUtil.formatShortMonthNameDay(publicationDate)}',
            style: textStyle.copyWith(color: mainColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (canShowReadTime)
          Text(
            '${showPublisher || canShowDate ? ' · ' : ''}${LocaleKeys.article_readMinutes.tr(
              args: [timeToRead.toString()],
            )}',
            style: textStyle.copyWith(color: mainColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
