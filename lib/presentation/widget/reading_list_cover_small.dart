import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReadingListCoverSmall extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ReadingListCoverSmall({
    required this.topic,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                CloudinaryImageExtension.withPublicId(topic.coverImage.publicId)
                    .transform()
                    .height(DimensionUtil.getPhysicalPixelsAsInt(constraints.maxHeight, context))
                    .fit()
                    .generateNotNull(),
              ),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.s),
                child: _AuthorRow(topic: topic),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, -0.25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                    child: InformedMarkdownBody(
                      markdown: topic.title,
                      baseTextStyle: AppTypography.h0SemiBold.copyWith(fontSize: 20),
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.m),
              Container(
                height: 1.0,
                color: AppColors.textPrimary,
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimens.s),
                child: Text(
                  LocaleKeys.readingList_articleCount.tr(
                    args: [
                      topic.readingList.articles.length.toString(),
                    ],
                  ),
                  style: AppTypography.metadata1Regular.copyWith(fontSize: 10),
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
        Image.asset(
          AppRasterGraphics.editorSample,
          width: AppDimens.m,
          height: AppDimens.m,
        ),
        const SizedBox(width: AppDimens.s),
        Text(
          'By Editorial Team', // TODO probably will be coming from API
          style: AppTypography.metadata2Bold.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
