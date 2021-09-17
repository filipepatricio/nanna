import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReadingListCover extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ReadingListCover({
    required this.topic,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: NetworkImage('url'),  // TODO will be coming from API
          //     fit: BoxFit.cover,
          //     alignment: Alignment.center,
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.l),
                child: _AuthorRow(topic: topic),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: InformedMarkdownBody(
                      markdown: topic.title,
                      baseTextStyle: AppTypography.h0SemiBold,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.s),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _EditorsNote(),
              ),
              const SizedBox(height: AppDimens.m),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _PublisherLogoRow(topic: topic),
              ),
              const SizedBox(height: AppDimens.m),
              Container(
                height: 1.0,
                color: AppColors.textPrimary,
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimens.l),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.readingList_articleCount.tr(
                        args: [
                          topic.readingList.articles.length.toString(),
                        ],
                      ),
                      style: AppTypography.metadata1Regular,
                    ),
                    const Spacer(),
                    const ReadMoreLabel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final Topic topic;

  const _AuthorRow({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppRasterGraphics.editorSample),
        const SizedBox(width: AppDimens.s),
        Text(
          'By Editorial Team', // TODO probably will be coming from API
          style: AppTypography.metadata2Bold.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class _EditorsNote extends StatelessWidget {
  const _EditorsNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            // TODO will be coming from API
            text: 'Editors note: ',
            style: AppTypography.h5BoldSmall,
          ),
          TextSpan(
            // TODO will be coming from API
            text: 'Afghan capital on Sunday amid scenes of panic and chaos, bringing a swift.',
            style: AppTypography.h5MediumSmall,
          ),
        ],
      ),
    );
  }
}

class _PublisherLogoRow extends StatelessWidget {
  final Topic topic;

  const _PublisherLogoRow({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: AppDimens.l, height: AppDimens.l, color: AppColors.black),
        const SizedBox(width: AppDimens.s),
        Container(width: AppDimens.l, height: AppDimens.l, color: AppColors.black),
        const SizedBox(width: AppDimens.s),
        Container(width: AppDimens.l, height: AppDimens.l, color: AppColors.black),
      ],
    );
  }
}
