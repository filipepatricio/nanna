import 'dart:ui' as ui;

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/widgets.dart';

const _publisherMaxWidthRatio = 0.5;

class ArticleDottedInfo extends StatelessWidget {
  const ArticleDottedInfo({
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
  })  : assert(
          showPublisher || showDate || showReadTime,
          'Select at least one of the sections to show',
        ),
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
    final finalTextStyle = textStyle.copyWith(color: mainColor, height: 1.0);
    final timeToRead = article.timeToRead;
    final publicationDate = article.publicationDate;

    final canShowReadTime = showReadTime && timeToRead != null;
    final canShowDate = showDate && publicationDate != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final String publisherName = article.publisher.name;
        final publisherNameSpan = TextSpan(
          text: publisherName,
          style: finalTextStyle,
        );
        final publisherNameTextPainter = TextPainter(
          text: publisherNameSpan,
          textDirection: ui.TextDirection.ltr,
        );
        publisherNameTextPainter.layout(maxWidth: constraints.maxWidth);

        final publisherNameWidthRatio = publisherNameTextPainter.size.width / constraints.maxWidth;
        final renderInTwoRows = publisherNameWidthRatio >= _publisherMaxWidthRatio;

        return Wrap(
          runAlignment: WrapAlignment.center,
          alignment: centerContent ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (showPublisher) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: centerContent ? MainAxisAlignment.center : MainAxisAlignment.start,
                mainAxisSize: renderInTwoRows ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (showLogo) ...[
                    if (isLight)
                      PublisherLogo.light(publisher: article.publisher)
                    else
                      PublisherLogo.dark(publisher: article.publisher),
                  ],
                  Flexible(
                    child: Text(
                      publisherName,
                      style: finalTextStyle,
                      maxLines: publisherMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showPublisher && (canShowDate || canShowReadTime) && !renderInTwoRows)
                  Text(' · ', style: finalTextStyle),
                if (canShowDate) ...[
                  Text(
                    fullDate
                        ? DateFormatUtil.formatFullMonthNameDayYear(publicationDate)
                        : DateFormatUtil.formatShortMonthNameDay(publicationDate),
                    style: finalTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (canShowReadTime)
                  Text(
                    '${canShowDate ? ' · ' : ''}${LocaleKeys.article_readMinutes.tr(
                      args: [timeToRead.toString()],
                    )}',
                    style: finalTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            )
          ],
        );
      },
    );
  }
}
