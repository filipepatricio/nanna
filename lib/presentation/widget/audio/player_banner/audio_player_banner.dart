import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/current_audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AudioPlayerBanner extends HookWidget {
  const AudioPlayerBanner({
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = useCubit<AudioPlayerBannerCubit>(closeOnDispose: false);
    final state = useCubitBuilder(cubit);
    final snackbarController = useSnackbarController();

    useCubitListener<AudioPlayerBannerCubit, AudioPlayerBannerState>(cubit, (cubit, current, context) {
      current.mapOrNull(
        freeArticlesLeft: (value) {
          snackbarController.showMessage(
            SnackbarMessage.simple(
              message: value.message,
              subMessage: l10n.subscription_snackbar_link,
              action: SnackbarAction(
                label: l10n.subscription_snackbar_action,
                callback: () => context.pushRoute(const SubscriptionPageRoute()),
              ),
              type: SnackbarMessageType.subscription,
            ),
          );
        },
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    final animationController = useAnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      initialValue: state.maybeMap(
        visible: (_) => 1.0,
        orElse: () => 0,
      ),
    );
    final sizeTween = Tween(begin: 0.0, end: 1.0).chain(
      CurveTween(
        curve: Curves.easeInOut,
      ),
    );
    final sizeAnimation = animationController.drive(sizeTween);

    useEffect(
      () {
        state.animate(animationController);
      },
      [state],
    );

    return Hero(
      tag: 'audio_banner',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        final unoperativeSnackbarController = SnackbarController();

        return Provider.value(
          value: unoperativeSnackbarController,
          child: _Banner(
            cubit: cubit,
            state: state,
            sizeAnimation: sizeAnimation,
            onTap: null,
          ),
        );
      },
      child: _Banner(
        cubit: cubit,
        state: state,
        sizeAnimation: sizeAnimation,
        onTap: onTap,
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.cubit,
    required this.state,
    required this.sizeAnimation,
    required this.onTap,
  });

  final AudioPlayerBannerCubit cubit;
  final AudioPlayerBannerState state;
  final Animation<double> sizeAnimation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bottomSpacing = MediaQuery.of(context).padding.bottom;
    final height = AppDimens.audioBannerHeight + MediaQuery.of(context).padding.bottom;

    return Material(
      child: SizeTransition(
        sizeFactor: sizeAnimation,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: state.getOnTap(context, onTap),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: AppColors.of(context).backgroundPrimary,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const SizedBox(width: AppDimens.pageHorizontalMargin),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: bottomSpacing),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.optionalTitle,
                              style: AppTypography.articleSmallTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.m),
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomSpacing),
                      child: Row(
                        children: [
                          _AudioControlButton(state: state),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: cubit.stop,
                            child: const Padding(
                              padding: EdgeInsets.all(AppDimens.s + AppDimens.xs),
                              child: InformedSvg(AppVectorGraphics.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CurrentAudioProgressBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioControlButton extends StatelessWidget {
  const _AudioControlButton({
    required this.state,
    Key? key,
  }) : super(key: key);

  final AudioPlayerBannerState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.audioControlButtonSize,
      height: AppDimens.audioControlButtonSize,
      child: FittedBox(
        child: state.maybeMap(
          visible: (state) {
            return const AudioControlButton.forCurrentAudio(
              elevation: 0,
              progressSize: AppDimens.audioControlButtonSize,
            );
          },
          orElse: () {},
        ),
      ),
    );
  }
}

extension on AudioPlayerBannerState {
  String get optionalTitle {
    return map(
      notInitialized: (_) => '',
      visible: (state) => state.audioItem.title,
      hidden: (_) => '',
      freeArticlesLeft: (_) => '',
    );
  }

  VoidCallback? getOnTap(BuildContext context, VoidCallback? onTap) {
    return map(
      notInitialized: (_) => null,
      visible: (state) =>
          onTap ??
          () {
            final articleDetails = state.article;
            if (articleDetails != null) {
              AutoRouter.of(context).push(
                AudioPageRoute(
                  article: articleDetails.metadata,
                  audioFile: articleDetails.audioFile,
                ),
              );
            }
          },
      hidden: (_) => null,
      freeArticlesLeft: (_) => null,
    );
  }

  void animate(AnimationController controller) {
    map(
      notInitialized: (_) => controller.reverse(),
      visible: (_) => controller.forward(),
      hidden: (_) => controller.reverse(),
      freeArticlesLeft: (_) {},
    );
  }
}
