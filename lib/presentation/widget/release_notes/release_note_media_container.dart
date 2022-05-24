import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note.dart';
import 'package:better_informed_mobile/domain/release_notes/data/release_note_media.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
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

    return Stack(
      children: [
        if (releaseNote.hasMultipleMedia)
          _MultiMediaContainer(
            releaseNote: releaseNote,
            pageController: controller,
          )
        else
          _MediaView(media: releaseNote.media.first),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: SvgPicture.asset(AppVectorGraphics.close),
            onPressed: () => context.popRoute(),
          ),
        ),
        if (releaseNote.hasMultipleMedia)
          Positioned(
            left: 0,
            right: 0,
            bottom: AppDimens.m,
            child: Center(
              child: PageDotIndicator(
                controller: controller,
                pageCount: releaseNote.media.length,
              ),
            ),
          ),
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
      image: (media) => Image.network(
        media.url,
        fit: BoxFit.cover,
      ),
      video: (media) => _VideoContainer(videoUrl: media.url),
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
        return controller.isInitialized
            ? _Video(videoController: videoController)
            : const Center(child: CircularProgressIndicator());
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
        showControlsOnInitialize: true,
        fullScreenByDefault: true,
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
