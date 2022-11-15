import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/mediaitems/topic_media_items_list.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TopicView extends HookWidget {
  const TopicView({
    required this.topic,
    required this.cubit,
    required this.scrollController,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final TopicPageCubit cubit;
  final ScrollController scrollController;
  final GlobalKey? mediaItemKey;

  static const bottomPaddingKey = Key('topic-view-bottom-padding');

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackingController();
    final pageIndex = useState(0);
    final topicSummary = topic.summary;

    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: AppDimens.m),
                CurationInfoView(
                  curationInfo: topic.curationInfo,
                  onTap: () => context.pushRoute(
                    TopicOwnerPageRoute(owner: topic.curationInfo.curator, fromTopicSlug: topic.slug),
                  ),
                ),
                const SizedBox(height: AppDimens.m),
                InformedMarkdownBody(
                  markdown: topic.introduction,
                  maxLines: 5,
                  baseTextStyle: AppTypography.b2Regular,
                ),
                const SizedBox(height: AppDimens.l),
                PublisherLogoRow(topic: topic.asPreview),
                const SizedBox(height: AppDimens.xxxl),
                if (topicSummary != null) ...[
                  InformedMarkdownBody(
                    markdown: LocaleKeys.topic_summaryTitle.tr(),
                    baseTextStyle: AppTypography.h0Medium,
                    maxLines: 1,
                  ),
                  const SizedBox(height: AppDimens.l),
                  InformedMarkdownBody(
                    markdown: topicSummary,
                    baseTextStyle: AppTypography.b2Regular,
                    paddingBuilders: <String, MarkdownPaddingBuilder>{
                      'ul': ULPaddingBuilder(),
                    },
                    bulletPadding: const EdgeInsets.only(top: AppDimens.xs),
                  ),
                  const SizedBox(height: AppDimens.xxl),
                ],
                InformedMarkdownBody(
                  markdown: LocaleKeys.topic_articlesTitle.tr(),
                  baseTextStyle: AppTypography.h0Medium,
                  maxLines: 1,
                ),
                const SizedBox(height: AppDimens.xl),
              ],
            ),
          ),
        ),
        TopicMediaItemsList(
          topic: topic,
          cubit: cubit,
          eventController: eventController,
          mediaItemKey: pageIndex.value == 0 ? mediaItemKey : null,
        ),
        const SliverPadding(
          key: bottomPaddingKey,
          padding: EdgeInsets.only(bottom: AppDimens.xl),
        ),
        const SliverToBoxAdapter(
          child: AudioPlayerBannerPlaceholder(),
        ),
      ],
    );
  }
}

class ULPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(bottom: AppDimens.ml);
}
