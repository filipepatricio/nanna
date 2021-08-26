import 'package:better_informed_mobile/domain/topic/data/topic.dart';
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
    final listScrollController = useScrollController();
    final articleController = usePageController();
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
      child: ListView(
        controller: listScrollController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _TopicHeader(
            index: index,
            pageTransitionAnimation: pageTransitionAnimation,
            topic: topic,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.l),
            color: AppColors.lightGrey,
            child: InformedMarkdownBody(
              markdown: topic.summary,
              baseTextStyle: AppTypography.b1Medium,
              selectable: true,
            ),
          ),
          Container(
            height: topicPageHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.xs),
                  child: VerticalIndicators(
                    currentIndex: pageIndex.value,
                    pageListLength: mockedList.length,
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: articleController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) => pageIndex.value = index,
                    children: [
                      ...mockedList.map(
                            (article) => ArticleItemView(
                          article: article,
                          index: index,
                          articleListLength: mockedList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
            height: MediaQuery.of(context).size.height * 0.65,
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
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
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
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: pageTransitionAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.info)),
                      const SizedBox(height: AppDimens.m),
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.share)),
                      const SizedBox(height: AppDimens.m),
                      IconButton(onPressed: () {}, icon: SvgPicture.asset(AppVectorGraphics.follow)),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                Hero(
                  tag: HeroTag.dailyBriefTopicTitle(topic.id),
                  child: InformedMarkdownBody(
                    markdown: topic.title,
                    baseTextStyle: AppTypography.h1Bold.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.s),
                Hero(
                  tag: HeroTag.dailyBriefTopicSummary(topic.id),
                  child: InformedMarkdownBody(
                    markdown: topic.introduction,
                    baseTextStyle: AppTypography.b1Medium.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
