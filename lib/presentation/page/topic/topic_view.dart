import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/vertical_indicators.dart';
import 'package:better_informed_mobile/presentation/page/topic/summary/summary_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/util/topic_custom_vertical_drag_manager.dart';
import 'package:better_informed_mobile/presentation/widget/author_widget.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _summaryViewHeight = 580.0;

const _topicHeaderPadding = 45.0;
const _topicHeaderImageHeight = 540.0;
const _topicHeaderHeight = 330.0;
const _articleCountLabelHeight = 72.0;

class TopicView extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final double articleContentHeight;
  final double? appBarMargin;
  final GlobalKey? summaryCardKey;
  final GlobalKey? mediaItemKey;

  const TopicView({
    required this.topic,
    required this.cubit,
    required this.articleContentHeight,
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
    final articleController = usePageController();
    final gestureManager = useMemoized(
      () => TopicCustomVerticalDragManager(
        generalViewController: listScrollController,
        pageViewController: articleController,
        topMargin: appBarMargin,
      ),
      [appBarMargin],
    );

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(shouldShowSummaryCardTutorialCoachMark: () {
        final listener = summaryCardTutorialListener(listScrollController);
        listScrollController.addListener(listener);
      }, shouldShowMediaItemTutorialCoachMark: () {
        final listener = mediaItemTutorialListener(listScrollController, articleContentHeight);
        listScrollController.addListener(listener);
      });
    });

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(), (VerticalDragGestureRecognizer instance) {
          instance
            ..onStart = gestureManager.handleDragStart
            ..onUpdate = gestureManager.handleDragUpdate
            ..onEnd = gestureManager.handleDragEnd
            ..onCancel = gestureManager.handleDragCancel;
        })
      },
      behavior: HitTestBehavior.opaque,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: NoScrollGlow(
          child: ListView(
            shrinkWrap: true,
            controller: listScrollController,
            physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            children: [
              _TopicHeader(
                topic: topic,
                onArticlesLabelTap: () {
                  gestureManager.animateTo(
                    _topicHeaderHeight + _summaryViewHeight + articleContentHeight,
                  );
                },
              ),
              SummaryContent(
                topic: topic,
                summaryCardKey: summaryCardKey,
              ),
              GeneralEventTracker(
                controller: eventController,
                child: _MediaItemContent(
                  articleContentHeight: articleContentHeight,
                  controller: articleController,
                  pageIndex: pageIndex,
                  topic: topic,
                  eventController: eventController,
                  mediaItemKey: pageIndex.value == 0 ? mediaItemKey : null,
                ),
              ),
            ],
          ),
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

  VoidCallback summaryCardTutorialListener(ScrollController listScrollController) {
    var isToShowSummaryCardTutorialCoachMark = true;
    final summaryCardTutorialListener = () {
      const summaryCardTriggerPosition = _topicHeaderImageHeight - _topicHeaderPadding;
      if (didListScrollReachSummaryCard(listScrollController, summaryCardTriggerPosition) &&
          isToShowSummaryCardTutorialCoachMark) {
        listScrollController.animateTo(summaryCardTriggerPosition,
            duration: const Duration(milliseconds: 100), curve: Curves.decelerate);
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
  final Topic topic;
  final void Function() onArticlesLabelTap;

  const _TopicHeader({
    required this.topic,
    required this.onArticlesLabelTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: _topicHeaderImageHeight,
          child: CloudinaryProgressiveImage(
            width: screenWidth,
            height: _topicHeaderImageHeight,
            cloudinaryTransformation: cloudinaryProvider
                .withPublicIdAsJpg(topic.heroImage.publicId)
                .transform()
                .withLogicalSize(screenWidth, _topicHeaderImageHeight, context)
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
          bottom: _topicHeaderPadding,
          right: _topicHeaderPadding,
          child: Container(
            width: _topicHeaderHeight,
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthorRow(topic: topic),
                  const SizedBox(height: AppDimens.s),
                  InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.hBold,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimens.l),
                  ExpandTapWidget(
                    onTap: onArticlesLabelTap,
                    tapPadding: const EdgeInsets.symmetric(vertical: AppDimens.ml),
                    child: Text(
                      LocaleKeys.todaysTopics_selectedArticles.tr(
                        args: [topic.readingList.entries.length.toString()],
                      ),
                      style: AppTypography.b1Regular.copyWith(
                        height: 1,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: AppDimens.topicControlsMargin),
                  Wrap(
                    children: [
                      UpdatedLabel(
                        dateTime: topic.lastUpdatedAt,
                        backgroundColor: AppColors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.s),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaItemContent extends HookWidget {
  final double articleContentHeight;
  final PageController controller;
  final ValueNotifier<int> pageIndex;
  final Topic topic;
  final GeneralEventTrackerController eventController;
  final GlobalKey? mediaItemKey;

  const _MediaItemContent({
    required this.articleContentHeight,
    required this.controller,
    required this.pageIndex,
    required this.topic,
    required this.eventController,
    this.mediaItemKey,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final entryList = topic.readingList.entries;

    useEffect(
      () {
        _trackReadingListBrowse(0);
      },
      [topic],
    );

    return Container(
      height: articleContentHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: NoScrollGlow(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                controller: controller,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  _trackReadingListBrowse(index);
                  pageIndex.value = index;
                },
                itemCount: entryList.length,
                itemBuilder: (context, index) {
                  final currentMediaItem = entryList[index].item;
                  //TODO: Handling different media types
                  if (currentMediaItem is MediaItemArticle) {
                    return ArticleItemView(
                      index: index,
                      topic: topic,
                      statusBarHeight: statusBarHeight + _articleCountLabelHeight,
                      navigationCallback: (index) => controller.jumpToPage(index),
                      mediaItemKey: index == 0 ? mediaItemKey : null,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: AppDimens.zero,
            right: AppDimens.zero,
            top: AppDimens.zero,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Text(
                LocaleKeys.todaysTopics_articlesCount.tr(args: [topic.readingList.entries.length.toString()]),
                style: AppTypography.h2Jakarta,
                maxLines: 1,
              ),
            ),
          ),
          Positioned.fill(
            top: statusBarHeight + _articleCountLabelHeight,
            right: null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l) + const EdgeInsets.only(bottom: AppDimens.m),
              child: VerticalIndicators(
                currentIndex: pageIndex.value,
                pageListLength: entryList.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _trackReadingListBrowse(int index) {
    final event = AnalyticsEvent.readingListBrowsed(
      topic.id,
      index,
    );
    eventController.track(event);
  }
}
