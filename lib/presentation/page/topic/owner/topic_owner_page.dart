import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_error_view.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/stacked_cards_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const appBarHeight = kToolbarHeight + AppDimens.m;
const _cardsSectionHeight = 550.0;
const _cardViewportFraction = 0.85;

class TopicOwnerPage extends HookWidget {
  final TopicOwner owner;
  final List<Topic> topics;

  const TopicOwnerPage({
    required this.owner,
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicOwnerPageCubit>();
    final state = useCubitBuilder(cubit);
    final cardStackWidth = MediaQuery.of(context).size.width * _cardViewportFraction;

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
                    child: TopicOwnerAvatar(owner: owner, profileMode: true),
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
                      idleExpert: (state) => _LastUpdatedTopics(topics: state.topicsFromExpert),
                      loading: (_) => SizedBox(
                        height: _cardsSectionHeight,
                        child: StackedCardsLoadingView(
                          padding: EdgeInsets.zero,
                          cardStackWidth: cardStackWidth,
                          subtitle: LocaleKeys.topic_owner_loadingExpertTopics.tr(args: [owner.name]),
                        ),
                      ),
                      error: (_) => SizedBox(
                        height: _cardsSectionHeight,
                        child: StackedCardsErrorView(
                          padding: EdgeInsets.zero,
                          cardStackWidth: cardStackWidth,
                        ),
                      ),
                      orElse: () => const SizedBox(),
                    ),
                    const SizedBox(height: AppDimens.l),
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
                    (owner is Editor ? LocaleKeys.topic_owner_editorialTeam.tr() : LocaleKeys.topic_owner_expert.tr())
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

  const _LastUpdatedTopics({required this.topics, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topicsController = usePageController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _cardsSectionHeight,
          child: PageView.builder(
            padEnds: false,
            controller: topicsController,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: AppDimens.xxl),
              child: ReadingListStackedCards(
                coverSize: Size(MediaQuery.of(context).size.width * _cardViewportFraction, _cardsSectionHeight),
                child: ReadingListCover(
                  topic: topics[index],
                  onTap: () {},
                ),
              ),
            ),
            itemCount: topics.length,
          ),
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
