import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/header/topic_header.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_shadow.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_button/share_topic_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

part 'app_bar/topic_app_bar.dart';
part 'topic_loading_view.dart';

class TopicPage extends HookWidget {
  const TopicPage({
    @pathParam required this.topicSlug,
    this.topic,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final String topicSlug;
  final Topic? topic;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicPageCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        final nullableTopic = topic;

        if (nullableTopic == null) {
          cubit.initializeWithSlug(topicSlug, briefId);
        } else {
          cubit.initialize(nullableTopic, briefId);
        }
      },
      [topicSlug, cubit],
    );

    return _TopicPage(
      state: state,
      cubit: cubit,
      topicSlug: topicSlug,
      briefId: briefId,
    );
  }
}

class _TopicPage extends StatelessWidget {
  const _TopicPage({
    required this.state,
    required this.cubit,
    required this.topicSlug,
    required this.briefId,
    Key? key,
  }) : super(key: key);

  final TopicPageState state;
  final TopicPageCubit cubit;
  final String topicSlug;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: state.maybeMap(
        idle: (_) => null,
        orElse: () => InformedCupertinoAppBar(
          backgroundColor: state.maybeMap(loading: (_) => AppColors.transparent, orElse: () => null),
        ),
      ),
      body: InformedAnimatedSwitcher(
        child: state.maybeMap(
          idle: (state) => _TopicIdleView(
            topic: state.topic,
            cubit: cubit,
          ),
          loading: (_) => const TopicLoadingView(),
          error: (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.xxxc),
            child: Center(
              child: GeneralErrorView(
                title: LocaleKeys.common_error_title.tr(),
                content: LocaleKeys.common_error_body.tr(),
                retryCallback: () => cubit.initializeWithSlug(topicSlug, briefId),
              ),
            ),
          ),
          orElse: Container.new,
        ),
      ),
    );
  }
}

class _TopicIdleView extends HookWidget {
  const _TopicIdleView({
    required this.topic,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final TopicPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useMemoized(() => SnackbarController());
    final scrollController = useScrollController(keepScrollOffset: true);
    final isShowingTutorialToast = useState(false);
    final isScrolled = useValueNotifier(false);

    useEffect(
      () {
        cubit.initializeTutorialStep();
      },
      [cubit],
    );

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) {
          isShowingTutorialToast.value = true;
          showInfoToast(
            context: context,
            text: text,
            onDismiss: () {
              isShowingTutorialToast.value = false;
            },
          );
        },
      );
    });

    void updateAppBar() {
      final scrolled = scrollController.offset > kToolbarHeight;
      isScrolled.value = scrolled;
    }

    useEffect(
      () {
        scrollController.addListener(updateAppBar);
        return () => scrollController.removeListener(updateAppBar);
      },
      [scrollController],
    );

    return ScrollsToTop(
      onScrollsToTop: (_) => scrollController.animateToStart(),
      child: SnackbarParentView(
        controller: snackbarController,
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: getPlatformScrollPhysics(
                const AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: TopicHeader(topic: topic),
                ),
                TopicView(
                  topic: topic,
                  cubit: cubit,
                  scrollController: scrollController,
                  snackbarController: snackbarController,
                  mediaItemKey: cubit.mediaItemKey,
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopicAppBar(
                topic: topic,
                cubit: cubit,
                isScrolled: isScrolled,
                snackbarController: snackbarController,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isScrolled,
              builder: (context, scrolled, banner) => AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                bottom: scrolled ? 0 : -AppDimens.xxxc,
                left: 0,
                right: 0,
                child: banner!,
              ),
              child: const AudioPlayerBannerShadow(
                child: AudioPlayerBanner(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
