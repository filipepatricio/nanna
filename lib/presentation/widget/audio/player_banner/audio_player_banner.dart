import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/current_audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
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
    final cubit = useCubit<AudioPlayerBannerCubit>(closeOnDispose: false);
    final state = useCubitBuilder(cubit);

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

    final bottomSpacing = MediaQuery.of(context).padding.bottom;
    final height = AppDimens.audioBannerHeight + MediaQuery.of(context).padding.bottom;

    return Hero(
      tag: 'audio_banner',
      child: Material(
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
            return const AudioFloatingControlButton.forCurrentAudio(
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
    );
  }

  void animate(AnimationController controller) {
    map(
      notInitialized: (_) => controller.reverse(),
      visible: (_) => controller.forward(),
      hidden: (_) => controller.reverse(),
    );
  }
}
