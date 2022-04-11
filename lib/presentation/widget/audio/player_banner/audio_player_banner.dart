import 'package:auto_route/auto_route.dart';
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
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/simple_audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _imageWidth = 80.0;
const _imageHeight = 80.0;

class AudioPlayerBanner extends HookWidget {
  const AudioPlayerBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioPlayerBannerCubit>();
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
    );
    final slideTween = Tween(begin: const Offset(0, -200), end: Offset.zero);
    final slideAnimation = animationController.drive(slideTween);

    useEffect(
      () {
        state.animate(animationController);
      },
      [state],
    );

    final imageUrl = state.imageUrl;

    return SlideTransition(
      position: slideAnimation,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: state.getOnTap(context),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: AppColors.grey,
                width: 1,
              ),
            ),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: AppDimens.audioBannerHeight,
                child: Row(
                  children: [
                    if (imageUrl != null)
                      CloudinaryProgressiveImage(
                        cloudinaryTransformation: CloudinaryImage(imageUrl).transform(),
                        width: _imageWidth,
                        height: _imageHeight,
                        testImage: AppRasterGraphics.testArticleHeroImage,
                      ),
                    const SizedBox(width: AppDimens.l),
                    Expanded(
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
                    const SizedBox(width: AppDimens.l),
                    _AudioControlButton(state: state),
                    const SizedBox(width: AppDimens.xxl),
                  ],
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SimpleAudioProgressBar(),
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
      width: AppDimens.xxl + AppDimens.xxs,
      height: AppDimens.xxl + AppDimens.xxs,
      child: FittedBox(
        child: state.maybeMap(
          visible: (state) {
            return const AudioFloatingControlButton.forCurrentAudio(
              elevation: 0,
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
              slug: '',
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
