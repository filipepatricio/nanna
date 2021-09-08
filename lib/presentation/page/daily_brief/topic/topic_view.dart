import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/vertical_indicators.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/topic_custom_vertical_drag_manager.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class TopicView extends HookWidget {
  final int index;
  final AnimationController pageTransitionAnimation;
  final Topic topic;
  final double topicPageHeight;

  const TopicView({
    required this.index,
    required this.pageTransitionAnimation,
    required this.topic,
    required this.topicPageHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageIndex = useState(0);
    final pageNotesIndex = useState(0);
    final listScrollController = useScrollController();
    final articleController = usePageController();
    final notesController = usePageController(viewportFraction: 0.8);
    final gestureManager = useMemoized(() => TopicCustomVerticalDragManager(listScrollController, articleController));
    //TODO: REMOVE MOCKED LIST (mocked for more length)
    final mockedList = topic.readingList.articles + topic.readingList.articles;

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
          controller: listScrollController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: _TopicHeader(
                index: index,
                pageTransitionAnimation: pageTransitionAnimation,
                topic: topic,
              ),
            ),
            _SummaryContent(
              topic: topic,
              controller: notesController,
              pageNotesIndex: pageNotesIndex,
            ),
            _ArticleContent(
              topicPageHeight: topicPageHeight,
              controller: articleController,
              pageIndex: pageIndex,
              articleList: mockedList,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicHeader extends HookWidget {
  final int index;
  final AnimationController pageTransitionAnimation;
  final Topic topic;

  const _TopicHeader({
    required this.index,
    required this.pageTransitionAnimation,
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width * 2;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Hero(
          tag: HeroTag.dailyBriefTopicImage(topic.id),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.76,
            child: Image.network(
              CloudinaryImageExtension.withPublicId(topic.image.publicId)
                  .transform()
                  .width(imageWidth.ceil())
                  .fit()
                  .generate()!,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topLeft,
            ),
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
          bottom: AppDimens.c,
          child: FadeTransition(
            opacity: pageTransitionAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //TODO: missing data
                    Text(
                      'Updated 5 hours ago',
                      style: AppTypography.metadata1Regular.copyWith(color: AppColors.greyFont),
                    ),
                    const SizedBox(height: AppDimens.m),
                    //TODO: Add hero animation to title
                    InformedMarkdownBody(
                      markdown: topic.title,
                      baseTextStyle: AppTypography.h1Bold.copyWith(fontSize: 44),
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppDimens.ml),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppVectorGraphics.articles),
                        const SizedBox(width: AppDimens.s),
                        Text(
                          LocaleKeys.dailyBrief_selectedArticles
                              .tr(args: [topic.readingList.articles.length.toString()]),
                          style: AppTypography.b3Regular.copyWith(height: 1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.topicControlsMargin),
                    FadeTransition(
                      opacity: pageTransitionAnimation,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(AppVectorGraphics.follow, color: AppColors.black),
                            ),
                          ),
                          const SizedBox(width: AppDimens.m),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(AppVectorGraphics.share, color: AppColors.black),
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(AppVectorGraphics.clock),
                          const SizedBox(width: AppDimens.s),
                          Text(
                            LocaleKeys.article_readMinutes.tr(args: ['45']),
                            style: AppTypography.b3Regular.copyWith(height: 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.s),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryContent extends StatelessWidget {
  final PageController controller;
  final ValueNotifier<int> pageNotesIndex;
  final Topic topic;

  const _SummaryContent({
    required this.topic,
    required this.controller,
    required this.pageNotesIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.86,
      padding: const EdgeInsets.all(AppDimens.l),
      color: AppColors.lightGrey,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InformedMarkdownBody(
                markdown: 'The __bigger picture__',
                baseTextStyle: AppTypography.h1Bold.copyWith(fontSize: 28),
              ),
              const SizedBox(height: AppDimens.l),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  onPageChanged: (index) => pageNotesIndex.value = index,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        color: AppColors.limeGreenBleached,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppDimens.l),
                            child: Text(
                              'Lashkar Gah and the rest of the Helmand province have been at the heart of the US and British military campaigns.',
                              style: AppTypography.b2MediumSerif,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimens.c),
              if (topic.summary.isNotEmpty) ...[
                InformedMarkdownBody(
                  markdown: 'Why does it __matter to you?__',
                  baseTextStyle: AppTypography.h1Bold.copyWith(fontSize: 28),
                ),
                Container(
                  padding: const EdgeInsets.all(AppDimens.l),
                  color: AppColors.lightGrey,
                  child: InformedMarkdownBody(
                    markdown: topic.summary,
                    baseTextStyle: AppTypography.b1Medium,
                    selectable: true,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  final double topicPageHeight;
  final PageController controller;
  final ValueNotifier<int> pageIndex;
  final List<ArticleHeader> articleList;

  const _ArticleContent({
    required this.topicPageHeight,
    required this.controller,
    required this.pageIndex,
    required this.articleList,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: topicPageHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => pageIndex.value = index,
              itemCount: articleList.length,
              itemBuilder: (context, index) {
                return ArticleItemView(
                  article: articleList[index],
                  index: index,
                  articleListLength: articleList.length,
                  statusBarHeight: statusBarHeight,
                );
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
                pageListLength: articleList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
