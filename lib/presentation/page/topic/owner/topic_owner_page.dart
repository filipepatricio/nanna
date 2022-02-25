import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page_state.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const appBarHeight = kToolbarHeight + AppDimens.m;

class TopicOwnerPage extends HookWidget {
  final TopicOwner owner;

  const TopicOwnerPage({
    required this.owner,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicOwnerPageCubit>();
    final state = useCubitBuilder(cubit);
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;
    final cardStackHeight =
        MediaQuery.of(context).size.width * 0.5 > 450 ? MediaQuery.of(context).size.width * 0.5 : 450.0;
    final snackbarController = useMemoized(() => SnackbarController());

    useCubitListener<TopicOwnerPageCubit, TopicOwnerPageState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          browserError: (state) {
            showBrowserError(state.link, snackbarController);
          },
        );
      },
    );

    useEffect(() {
      if (owner is! Expert) {
        cubit.initialize();
        return;
      }

      cubit.initialize((owner as Expert).id);
    }, [owner]);

    final scrollController = useMemoized(
      () => ModalScrollController.of(context) ?? ScrollController(keepScrollOffset: true),
    );

    return Material(
      child: NoScrollGlow(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          slivers: [
            _ActionsBar(controller: scrollController, owner: owner),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: AppDimens.l),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: TopicOwnerAvatar(
                      owner: owner,
                      profileMode: true,
                      imageHeight: AppDimens.avatarSize * 1.3,
                      imageWidth: AppDimens.avatarSize * 1.3,
                    ),
                  ),
                  const SizedBox(height: AppDimens.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                    child: Text(
                      owner is Expert ? (owner as Expert).bio : LocaleKeys.topic_owner_editorBio.tr(),
                      softWrap: true,
                      style: AppTypography.b1Regular,
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(const HowDoWeCurateContentPageRoute());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                      child: Row(
                        children: [
                          Text(
                            LocaleKeys.topic_howDoWeCurateContent_label.tr(),
                            style: AppTypography.h3Bold16.copyWith(decoration: TextDecoration.underline),
                          ),
                          const SizedBox(width: AppDimens.xs),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.xl),
                  const BottomStackedCards(),
                  const SizedBox(height: AppDimens.m),
                  if (owner is Expert) ...[
                    const SizedBox(height: AppDimens.xl),
                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.l),
                      child: Text(
                        LocaleKeys.topic_owner_lastUpdated.tr(),
                        style: AppTypography.h3bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.l),
                    state.maybeMap(
                      idleExpert: (state) => _LastUpdatedTopics(
                        topics: state.topicsFromExpert,
                        cardStackHeight: cardStackHeight,
                      ),
                      loading: (_) => SizedBox(
                        height: cardStackHeight,
                        child: StackedCardsLoadingView(
                          padding: EdgeInsets.zero,
                          cardStackWidth: cardStackWidth,
                          subtitle: LocaleKeys.topic_owner_loadingExpertTopics.tr(args: [owner.name]),
                        ),
                      ),
                      error: (_) => SizedBox(
                        height: cardStackHeight,
                        child: StackedCardsErrorView(
                          padding: EdgeInsets.zero,
                          cardStackWidth: cardStackWidth,
                        ),
                      ),
                      orElse: () => const SizedBox(),
                    ),
                    const SizedBox(height: AppDimens.xxl),
                    if (owner is Expert && (owner as Expert).hasSocialMediaLinks) ...[
                      _SocialMediaLinks(
                        cubit: cubit,
                        owner: owner as Expert,
                      ),
                      const SizedBox(height: AppDimens.c),
                    ],
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsBar extends HookWidget {
  const _ActionsBar({required this.controller, required this.owner, Key? key}) : super(key: key);

  final TopicOwner owner;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final showOwnerTitle = useState(0.0);

    void setShowOwnerTitle() {
      if (controller.hasClients) {
        final currentOffset = controller.offset;
        const opacityThreshold = appBarHeight * 1.5;

        if (currentOffset <= 0 || currentOffset < opacityThreshold) {
          if (showOwnerTitle.value != 0) showOwnerTitle.value = 0;
          return;
        }

        if (showOwnerTitle.value != 1) showOwnerTitle.value = 1;
      }
    }

    useEffect(() {
      controller.addListener(setShowOwnerTitle);
      return () => controller.removeListener(setShowOwnerTitle);
    }, [controller]);

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      toolbarHeight: appBarHeight,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: AppColors.background,
      title: Container(
        height: appBarHeight,
        alignment: Alignment.center,
        color: AppColors.background,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: AppDimens.ml,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                color: AppColors.black,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                onPressed: () => context.popRoute(),
              ),
            ),
            Positioned(
              right: AppDimens.ml,
              child: AnimatedOpacity(
                opacity: 1 - showOwnerTitle.value,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.xxs),
                    color: owner is Editor ? AppColors.limeGreen : AppColors.peach10,
                  ),
                  child: Text(
                    (owner is Expert
                            ? LocaleKeys.topic_owner_expertIn.tr(args: [(owner as Expert).areaOfExpertise])
                            : LocaleKeys.topic_owner_editorialTeam.tr())
                        .toUpperCase(),
                    style: AppTypography.labelText,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: showOwnerTitle.value,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Text(owner.name, style: AppTypography.h3Bold16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LastUpdatedTopics extends HookWidget {
  final List<Topic> topics;
  final double cardStackHeight;

  const _LastUpdatedTopics({required this.topics, required this.cardStackHeight, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topicsController = usePageController(viewportFraction: AppDimens.topicCardWidthViewportFraction);
    final cardStackWidth = MediaQuery.of(context).size.width * AppDimens.topicCardWidthViewportFraction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: cardStackHeight,
          child: PageView.builder(
              padEnds: false,
              itemCount: topics.length,
              controller: topicsController,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 16),
                  child: PageViewStackedCards.random(
                    coverSize: Size(cardStackWidth, cardStackHeight),
                    child: ReadingListCover(
                      topic: topics[index],
                      onTap: () => _onTopicTap(context, topics[index]),
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
          child: PageDotIndicator(
            pageCount: topics.length,
            controller: topicsController,
          ),
        ),
      ],
    );
  }
}

void _onTopicTap(BuildContext context, Topic topic) {
  AutoRouter.of(context).push(
    TopicPage(
      topicSlug: topic.id,
      topic: topic,
    ),
  );
}

class _SocialMediaLinks extends StatelessWidget {
  final TopicOwnerPageCubit cubit;
  final Expert owner;

  const _SocialMediaLinks({
    required this.cubit,
    required this.owner,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instagram = owner.instagram;
    final linkedin = owner.linkedin;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.topic_owner_followExpertOn.tr(args: [owner.name]),
            style: AppTypography.b3Regular.copyWith(height: 2.0),
          ),
          const SizedBox(height: AppDimens.m),
          Row(
            children: [
              if (instagram != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.instagram,
                  onTap: () {
                    cubit.openSocialMediaLink(instagram);
                  },
                ),
              if (linkedin != null)
                _SocialMediaIcon(
                  icon: AppVectorGraphics.linkedin,
                  onTap: () {
                    cubit.openSocialMediaLink(linkedin);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialMediaIcon extends StatelessWidget {
  const _SocialMediaIcon({
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: AppDimens.l),
        child: SvgPicture.asset(
          icon,
          color: AppColors.socialNetworksIcon,
        ),
      ),
    );
  }
}
