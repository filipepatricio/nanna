import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AudioPlayerBannerShadow extends HookWidget {
  const AudioPlayerBannerShadow({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioPlayerBannerCubit>(
      closeOnDispose: false,
    );
    final state = useCubitBuilder(cubit);

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          ...state.maybeMap(
            visible: (_) => [
              const BoxShadow(
                color: AppColors.shadowColor,
                offset: Offset.zero,
                blurRadius: 1.0,
                spreadRadius: 0,
              ),
            ],
            orElse: () => [],
          ),
        ],
      ),
      child: child,
    );
  }
}
