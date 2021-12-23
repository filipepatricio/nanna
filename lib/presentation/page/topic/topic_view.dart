import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/mediaitems/topic_media_items_list.dart';
import 'package:better_informed_mobile/presentation/page/topic/summary/topic_summary.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicView extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final double? appBarMargin;
  final GlobalKey? summaryCardKey;
  final GlobalKey? mediaItemKey;

  const TopicView({
    required this.topic,
    required this.cubit,
    this.summaryCardKey,
    this.mediaItemKey,
    this.appBarMargin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();
    final pageIndex = useState(0);
    final listScrollController = useScrollController();
    final topicHeaderImageHeight = MediaQuery.of(context).size.height * .75;
    final summaryViewHeight = MediaQuery.of(context).size.height * .5;
    const articleSectionHeight = AppDimens.topicViewArticleSectionFullHeight;

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(shouldShowSummaryCardTutorialCoachMark: () {
        final listener = summaryCardTutorialListener(listScrollController, topicHeaderImageHeight);
        listScrollController.addListener(listener);
      }, shouldShowMediaItemTutorialCoachMark: () {
        final listener = mediaItemTutorialListener(listScrollController, articleSectionHeight);
        listScrollController.addListener(listener);
      });
    });

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: NoScrollGlow(
        child: ListView(
          shrinkWrap: true,
          controller: listScrollController,
          physics: const ClampingScrollPhysics(),
          children: [
            _TopicHeader(
              topic: topic,
              onArticlesLabelTap: () {
                listScrollController.animateTo(
                  AppDimens.topicViewTopicHeaderHeight + summaryViewHeight + articleSectionHeight,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                );
              },
              topicHeaderImageHeight: topicHeaderImageHeight,
            ),
            TopicSummary(
              topic: topic,
              summaryCardKey: summaryCardKey,
            ),
            Stack(
              children: [
                GeneralEventTracker(
                  controller: eventController,
                  child: TopicMediaItemsList(
                    pageIndex: pageIndex,
                    topic: topic,
                    eventController: eventController,
                    mediaItemKey: pageIndex.value == 0 ? mediaItemKey : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool didListScrollReachMediaItem(ScrollController listScrollController, double articleTriggerPosition) {
    return listScrollController.offset >= articleTriggerPosition && !listScrollController.position.outOfRange;
  }

  bool didListScrollReachSummaryCard(ScrollController listScrollController, double summaryCardTriggerPosition) {
    return listScrollController.offset >= summaryCardTriggerPosition && !listScrollController.position.outOfRange;
  }

  VoidCallback summaryCardTutorialListener(ScrollController listScrollController, double topicHeaderImageHeight) {
    var isToShowSummaryCardTutorialCoachMark = true;
    final summaryCardTutorialListener = () {
      final summaryCardTriggerPosition = topicHeaderImageHeight - AppDimens.topicViewTopicHeaderPadding;
      if (didListScrollReachSummaryCard(listScrollController, summaryCardTriggerPosition) &&
          isToShowSummaryCardTutorialCoachMark) {
        listScrollController.animateTo(
          summaryCardTriggerPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
        cubit.showSummaryCardTutorialCoachMark();
        isToShowSummaryCardTutorialCoachMark = false;
      }
    };
    return summaryCardTutorialListener;
  }

  VoidCallback mediaItemTutorialListener(ScrollController listScrollController, double articleContentHeight) {
    var isToShowMediaItemTutorialCoachMark = true;
    final mediaItemTutorialListener = () {
      if (isToShowMediaItemTutorialCoachMark &&
          didListScrollReachMediaItem(listScrollController, listScrollController.position.maxScrollExtent)) {
        listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
        cubit.showMediaItemTutorialCoachMark();
        isToShowMediaItemTutorialCoachMark = false;
      }
    };
    return mediaItemTutorialListener;
  }
}

class _TopicHeader extends HookWidget {
  const _TopicHeader({
    required this.topic,
    required this.onArticlesLabelTap,
    required this.topicHeaderImageHeight,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final double topicHeaderImageHeight;
  final void Function() onArticlesLabelTap;

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: topicHeaderImageHeight,
          child: CloudinaryProgressiveImage(
            width: screenWidth,
            height: topicHeaderImageHeight,
            cloudinaryTransformation: cloudinaryProvider
                .withPublicIdAsPlatform(topic.heroImage.publicId)
                .transform()
                .withLogicalSize(screenWidth, topicHeaderImageHeight, context)
                .autoGravity(),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: AppColors.black.withOpacity(0.4),
          ),
        ),
        Positioned(
          left: 0,
          bottom: AppDimens.topicViewTopicHeaderPadding,
          right: AppDimens.topicViewTopicHeaderPadding,
          child: Container(
            width: AppDimens.topicViewTopicHeaderHeight,
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopicOwnerAvatar(
                    owner: topic.owner,
                    onTap: () => AutoRouter.of(context).push(
                      TopicOwnerPageRoute(
                        owner: topic.owner,
                        topics: List.generate(3, (index) => topic),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.s),
                  InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.h1Headline,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimens.l),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SelectedArticlesLabel(onArticlesLabelTap: onArticlesLabelTap, topic: topic),
                      UpdatedLabel(
                        dateTime: topic.lastUpdatedAt,
                        backgroundColor: AppColors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedArticlesLabel extends StatelessWidget {
  const _SelectedArticlesLabel({
    required this.onArticlesLabelTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final void Function() onArticlesLabelTap;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      onTap: onArticlesLabelTap,
      tapPadding: const EdgeInsets.symmetric(vertical: AppDimens.ml),
      child: Text(
        LocaleKeys.todaysTopics_selectedArticles.tr(
          args: [topic.readingList.entries.length.toString()],
        ),
        textAlign: TextAlign.start,
        style: AppTypography.b1Regular.copyWith(decoration: TextDecoration.underline),
      ),
    );
  }
}
