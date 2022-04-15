import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AudioPlayerBannerPlaceholder extends HookWidget {
  const AudioPlayerBannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioPlayerBannerCubit>(
      closeOnDispose: false,
    );
    final state = useCubitBuilder(cubit);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: state.maybeMap(
        visible: (_) => AppDimens.audioBannerHeight + AppDimens.l,
        orElse: () => 0,
      ),
    );
  }
}
