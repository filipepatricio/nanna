import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/video_controls/release_note_video_controls_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/video_controls/release_note_video_controls_state.dt.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReleaseNoteVideoControls extends HookWidget {
  const ReleaseNoteVideoControls({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => ChewieController.of(context));
    final cubit = useCubit<ReleaseNoteVideoControlsCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        void onChange() {
          cubit.onVideoStateChange(controller.isPlaying);
        }

        controller.videoPlayerController.addListener(onChange);
        return () => controller.videoPlayerController.removeListener(onChange);
      },
      [controller],
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: state.map(
        empty: (state) => _Empty(onTap: cubit.toggleOverlay),
        overlay: (state) => _Overlay(
          state: state,
          controller: controller,
          onTap: cubit.toggleOverlay,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: const SizedBox.expand(),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({
    required this.state,
    required this.controller,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final ReleaseNoteVideoControlsState state;
  final ChewieController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.overlay,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              state.playing ? controller.pause() : controller.play();
            },
            child: Container(
              padding: const EdgeInsets.all(AppDimens.l),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.of(context).buttonSecondaryBackground,
              ),
              child: SvgPicture.asset(
                state.playing ? AppVectorGraphics.pause : AppVectorGraphics.playArrow,
                color: AppColors.of(context).buttonSecondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
