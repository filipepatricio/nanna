import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note_media.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/video_controls/release_note_video_controls.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class ReleaseNoteMediaContainer extends HookWidget {
  const ReleaseNoteMediaContainer({
    required this.releaseNote,
    super.key,
  });

  final ReleaseNote releaseNote;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (releaseNote.hasMultipleMedia)
                _MultiMediaContainer(
                  releaseNote: releaseNote,
                  pageController: controller,
                )
              else
                _MediaView(media: releaseNote.media.first),
              Positioned(
                top: AppDimens.m,
                right: AppDimens.m,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(AppVectorGraphics.close),
                    onPressed: () => context.popRoute(),
                    padding: const EdgeInsets.all(AppDimens.xs),
                    constraints: const BoxConstraints(),
                    splashRadius: AppDimens.l,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (releaseNote.hasMultipleMedia) ...[
          const SizedBox(height: AppDimens.m),
          Center(
            child: PageDotIndicator(
              controller: controller,
              pageCount: releaseNote.media.length,
            ),
          ),
        ]
      ],
    );
  }
}

class _MultiMediaContainer extends StatelessWidget {
  const _MultiMediaContainer({
    required this.releaseNote,
    required this.pageController,
  });

  final ReleaseNote releaseNote;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, index) => _MediaView(media: releaseNote.media[index]),
      itemCount: releaseNote.media.length,
    );
  }
}

class _MediaView extends StatelessWidget {
  const _MediaView({required this.media});

  final ReleaseNoteMedia media;

  @override
  Widget build(BuildContext context) {
    return media.map(
      image: (media) => _Image(url: media.url),
      video: (media) => _VideoContainer(videoUrl: media.url),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.url,
    Key? key,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    if (kIsTest) {
      return Image.asset(
        AppRasterGraphics.testTopicHeroImage,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }
}

class _VideoContainer extends HookWidget {
  const _VideoContainer({required this.videoUrl, Key? key}) : super(key: key);

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    final videoController = useMemoized(
      () => VideoPlayerController.network(videoUrl),
    );

    useEffect(
      () {
        videoController.initialize();
        return videoController.dispose;
      },
      [videoController],
    );

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoController,
      builder: (context, controller, view) {
        return controller.isInitialized ? _Video(videoController: videoController) : const Center(child: Loader());
      },
    );
  }
}

class _Video extends HookWidget {
  const _Video({
    required this.videoController,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController videoController;

  @override
  Widget build(BuildContext context) {
    final cheewieController = useMemoized(
      () => ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        customControls: const ReleaseNoteVideoControls(),
      ),
    );

    useEffect(
      () => cheewieController.dispose,
      [cheewieController],
    );

    return Chewie(controller: cheewieController);
  }
}

extension on ReleaseNote {
  bool get hasMultipleMedia => media.length > 1;
}
