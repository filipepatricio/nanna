import 'dart:ui' as ui;

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';

const _publisherMaxWidthRatio = 0.5;

class ArticleDottedInfo extends StatelessWidget {
  const ArticleDottedInfo({
    required this.article,
    this.mode = Brightness.dark,
    this.showPublisher = true,
    this.showLogo = true,
    this.showDate = true,
    this.fullDate = false,
    this.showReadTime = true,
    this.textStyle = AppTypography.metadata1Medium,
    this.color,
    this.publisherMaxLines = 1,
    this.centerContent = false,
    this.publisherLogoSize = AppDimens.publisherLogoSize,
    Key? key,
  })  : assert(
          showPublisher || showDate || showReadTime,
          'Select at least one of the sections to show',
        ),
        super(key: key);

  final MediaItemArticle article;
  final Brightness mode;
  final bool showPublisher;
  final bool showLogo;
  final bool showDate;
  final bool fullDate;
  final bool showReadTime;
  final TextStyle textStyle;
  final Color? color;
  final int publisherMaxLines;
  final bool centerContent;
  final double publisherLogoSize;

  @override
  Widget build(BuildContext context) {
    final darkMode = mode == Brightness.dark;

    final mainColor = color ?? (darkMode ? null : AppColors.of(context).blackWhiteSecondary);
    final finalTextStyle = textStyle.copyWith(color: mainColor);
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
                    if (darkMode)
                      PublisherLogo.dark(publisher: article.publisher, dimension: publisherLogoSize)
                    else
                      PublisherLogo.light(publisher: article.publisher, dimension: publisherLogoSize),
                    const SizedBox(width: AppDimens.xs),
                  ],
                  Flexible(
                    child: Text(
                      publisherName,
                      style: finalTextStyle.copyWith(height: showLogo ? 1.0 : null),
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
