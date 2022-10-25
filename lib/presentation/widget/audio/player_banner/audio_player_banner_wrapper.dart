import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_shadow.dart';
import 'package:flutter/material.dart';

enum AudioPlayerBannerLayout { stack, column }

class AudioPlayerBannerWrapper extends StatelessWidget {
  const AudioPlayerBannerWrapper({
    required this.layout,
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final AudioPlayerBannerLayout layout;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case AudioPlayerBannerLayout.stack:
        return _Stack(
          onTap: onTap,
          child: child,
        );
      case AudioPlayerBannerLayout.column:
        return _Column(
          onTap: onTap,
          child: child,
        );
    }
  }
}

class _Stack extends StatelessWidget {
  const _Stack({
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AudioPlayerBannerShadow(
            child: AudioPlayerBanner(
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({
    required this.child,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              child,
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AudioPlayerBannerShadow(
                  child: SizedBox(height: 1.0),
                ),
              ),
            ],
          ),
        ),
        AudioPlayerBanner(onTap: onTap),
      ],
    );
  }
}
