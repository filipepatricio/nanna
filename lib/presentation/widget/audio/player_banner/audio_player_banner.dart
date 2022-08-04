import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article_output_mode.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/current_audio_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _imageWidth = 80.0;

class AudioPlayerBanner extends HookWidget {
  const AudioPlayerBanner({
    Key? key,
  }) : super(key: key);

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

    final imageUrl = state.imageUrl;

    final bottomSpacing = MediaQuery.of(context).padding.bottom;
    final height = AppDimens.audioBannerHeight + MediaQuery.of(context).padding.bottom;

    return Hero(
      tag: 'audio_banner',
      child: Material(
        child: SizeTransition(
          sizeFactor: sizeAnimation,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: state.getOnTap(context),
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      if (imageUrl != null)
                        if (!kIsTest)
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: _imageWidth,
                            height: height,
                            fit: BoxFit.cover,
                          )
                        else
                          Image.asset(
                            AppRasterGraphics.testReadingListCoverImageCropped,
                            height: height,
                            width: _imageWidth,
                            fit: BoxFit.cover,
                          ),
                      const SizedBox(width: AppDimens.l),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tr(LocaleKeys.continueListening),
                                style: AppTypography.metadata1Regular.copyWith(color: AppColors.textGrey),
                              ),
                              Text(
                                state.optionalTitle,
                                style: AppTypography.b2Bold,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.l),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomSpacing),
                        child: _AudioControlButton(state: state),
                      ),
                      const SizedBox(width: AppDimens.xxl),
                    ],
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CurrentAudioProgressBar(),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => cubit.stop(),
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.s + AppDimens.xs),
                        child: SvgPicture.asset(
                          AppVectorGraphics.close,
                        ),
                      ),
                    ),
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

  VoidCallback? getOnTap(BuildContext context) {
    return map(
      notInitialized: (_) => null,
      visible: (state) => () => AutoRouter.of(context).push(
            MediaItemPageRoute(
              slug: state.audioItem.slug,
              articleOutputMode: ArticleOutputMode.audio,
            ),
          ),
      hidden: (_) => null,
    );
  }

  String? get imageUrl {
    return map(
      notInitialized: (_) => null,
      visible: (state) => state.audioItem.imageUrl,
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
