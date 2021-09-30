import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/author_widget.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReadingListCover extends HookWidget {
  final Topic topic;
  final VoidCallback? onTap;

  const ReadingListCover({
    required this.topic,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                cloudinaryProvider
                    .withPublicId(topic.coverImage.publicId)
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
                padding: const EdgeInsets.all(AppDimens.l),
                child: Hero(
                  tag: HeroTag.dailyBriefTopicAuthor(topic.id),
                  child: Material(
                    type: MaterialType.transparency,
                    child: AuthorRow(topic: topic),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, -0.25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: Hero(
                      tag: HeroTag.dailyBriefTopicTitle(topic.id),
                      flightShuttleBuilder: (_, anim, dir, from, to) {
                        return OverflowBox(
                          maxHeight: double.infinity,
                          child: to.widget,
                        );
                      },
                      child: Material(
                        type: MaterialType.transparency,
                        child: InformedMarkdownBody(
                          markdown: topic.title,
                          baseTextStyle: AppTypography.h0Bold,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.s),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _EditorsNote(),
              ),
              const SizedBox(height: AppDimens.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: _PublisherLogoRow(topic: topic),
              ),
              const SizedBox(height: AppDimens.l),
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
                        args: [topic.readingList.articles.length.toString()],
                      ),
                      style: AppTypography.b3Medium,
                    ),
                    const Spacer(),
                    UpdatedLabel(
                      text: 'Updated 2 days ago'.toUpperCase(),
                      backgroundColor: AppColors.white,
                    ),
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
