import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/vertical_indicators.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:better_informed_mobile/presentation/util/topic_custom_vertical_drag_manager.dart';
import 'package:better_informed_mobile/presentation/widget/author_widget.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/follow_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _summaryPageViewHeight = 365.0;
const _summaryViewHeight = 630.0;

const _topicHeaderPadding = 60.0;
const _topicHeaderImageHeight = 620.0;
const _topicHeaderHeight = 350.0;

class TopicView extends HookWidget {
  final Topic topic;
  final double articleContentHeight;
  final double? appBarMargin;

  const TopicView({
    required this.topic,
    required this.articleContentHeight,
    this.appBarMargin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          shrinkWrap: true,
          controller: listScrollController,
          physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          children: [
            _TopicHeader(topic: topic),
            _SummaryContent(topic: topic),
            _MediaItemContent(
              articleContentHeight: articleContentHeight,
              controller: articleController,
              pageIndex: pageIndex,
              entryList: topic.readingList.entries,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicHeader extends HookWidget {
  final Topic topic;

  const _TopicHeader({
    required this.topic,
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
            fit: BoxFit.fitHeight,
            width: screenWidth,
            height: _topicHeaderImageHeight,
            cloudinaryTransformation: cloudinaryProvider
                .withPublicId(topic.heroImage.publicId)
                .transform()
                .withLogicalSize(screenWidth, _topicHeaderImageHeight, context)
                .autoGravity(),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientOverlayStartColor,
                  AppColors.gradientOverlayEndColor,
                ],
              ),
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthorRow(topic: topic),
                  const SizedBox(height: AppDimens.m),
                  InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.hBold,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimens.ml),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppVectorGraphics.articles),
                      const SizedBox(width: AppDimens.s),
                      Text(
                        LocaleKeys.dailyBrief_selectedArticles.tr(
                          args: [topic.readingList.entries.length.toString()],
                        ),
                        style: AppTypography.b3Regular.copyWith(height: 1),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.topicControlsMargin),
                  Row(
                    children: [
                      FollowButton(onTap: () {}),
                      const SizedBox(width: AppDimens.m),
                      ShareButton(onTap: () {}),
                      const Spacer(),
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

class _SummaryContent extends HookWidget {
  final Topic topic;

  const _SummaryContent({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(viewportFraction: 0.85);

    if (topic.topicSummaryList.isEmpty) {
      return const SizedBox();
    }

    final content = topic.topicSummaryList.length > 1
        ? _SummaryCardPageView(
            topic: topic,
            controller: controller,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: _SummaryCard(
              index: 0,
              topic: topic,
            ),
          );

    return Container(
      width: double.infinity,
      height: _summaryViewHeight,

      ///This color should be the same as first article page view
      color: AppColors.mockedColors[0],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.lightGrey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimens.xl),
                Padding(
                  padding: const EdgeInsets.only(left: AppDimens.l),
                  child: Text(
                    LocaleKeys.dailyBrief_biggerPicture.tr(),
                    style: AppTypography.h1Medium,
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                content,
                const SizedBox(height: AppDimens.xl),
                if (topic.topicSummaryList.length > 1) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: PageDotIndicator(
                      pageCount: topic.topicSummaryList.length,
                      controller: controller,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),
                ],
              ],
            ),
          ),
          const BottomStackedCards(),
        ],
      ),
    );
  }
}

class _SummaryCardPageView extends StatelessWidget {
  final Topic topic;
  final PageController controller;

  const _SummaryCardPageView({
    required this.topic,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _summaryPageViewHeight,
      child: PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: topic.topicSummaryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimens.m),
            child: _SummaryCard(
              topic: topic,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int index;
  final Topic topic;

  const _SummaryCard({
    required this.index,
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _summaryPageViewHeight,
      padding: const EdgeInsets.only(
        left: AppDimens.l,
        right: AppDimens.l,
        bottom: AppDimens.l,
      ),
      color: AppColors.mockedColors[index % AppColors.mockedColors.length],
      child: Column(
        children: [
          const SizedBox(height: AppDimens.l),
          //TODO: Get data from api, remove if statement
          if (index % 2 == 0) ...[
            Image.asset(AppRasterGraphics.mockedComputerMan),
            const SizedBox(height: AppDimens.l),
          ],
          Expanded(
            child: InformedMarkdownBody(
              markdown: topic.topicSummaryList[index].content,
              baseTextStyle: AppTypography.b2MediumSerif,
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaItemContent extends StatelessWidget {
  final double articleContentHeight;
  final PageController controller;
  final ValueNotifier<int> pageIndex;
  final List<Entry> entryList;

  const _MediaItemContent({
    required this.articleContentHeight,
    required this.controller,
    required this.pageIndex,
    required this.entryList,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: articleContentHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              controller: controller,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => pageIndex.value = index,
              itemCount: entryList.length,
              itemBuilder: (context, index) {
                final currentMediaItem = entryList[index].item;
                //TODO: Handling different media types
                if (currentMediaItem is MediaItemArticle) {
                  return ArticleItemView(
                    article: currentMediaItem,
                    allEntries: entryList,
                    index: index,
                    statusBarHeight: statusBarHeight,
                    navigationCallback: (index) => controller.jumpToPage(index),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          Positioned.fill(
            top: statusBarHeight,
            right: null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.s),
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
}