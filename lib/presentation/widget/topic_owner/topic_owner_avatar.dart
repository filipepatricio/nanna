import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner/topic_owner_avatar_unknown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

part 'topic_owner_image.dart';
part 'topic_owner_avatar_big.dart';
part 'topic_owner_avatar_small.dart';

enum TopicOwnerAvatarStyle { big, small }

class TopicOwnerAvatar extends StatelessWidget {
  const TopicOwnerAvatar._({
    required this.owner,
    required this.style,
    required this.mode,
    this.shortLabel,
    this.onTap,
  });

  factory TopicOwnerAvatar.big({
    required TopicOwner owner,
    Brightness mode = Brightness.dark,
  }) =>
      TopicOwnerAvatar._(
        style: TopicOwnerAvatarStyle.big,
        owner: owner,
        mode: mode,
      );

  factory TopicOwnerAvatar.small({
    required TopicOwner owner,
    Brightness mode = Brightness.dark,
    bool shortLabel = false,
    VoidCallback? onTap,
  }) =>
      TopicOwnerAvatar._(
        style: TopicOwnerAvatarStyle.small,
        owner: owner,
        mode: mode,
        shortLabel: shortLabel,
        onTap: onTap,
      );

  final TopicOwnerAvatarStyle style;
  final TopicOwner owner;
  final Brightness mode;
  final bool? shortLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case TopicOwnerAvatarStyle.big:
        return _TopicOwnerAvatarBig(
          owner: owner,
          mode: mode,
        );
      case TopicOwnerAvatarStyle.small:
        return _TopicOwnerAvatarSmall(
          owner: owner,
          mode: mode,
          shortLabel: shortLabel!,
          onTap: onTap,
        );
    }
  }
}
