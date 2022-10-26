import 'package:better_informed_mobile/domain/article/data/article_curation_info.dart';
import 'package:better_informed_mobile/domain/topic/data/curator.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/curator_image.dart';
import 'package:flutter/material.dart';

class ArticleRecommendedByView extends StatelessWidget {
  const ArticleRecommendedByView({
    required this.curationInfo,
    super.key,
  });

  final ArticleCurationInfo curationInfo;

  @override
  Widget build(BuildContext context) {
    final curationInfo = this.curationInfo;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CuratorImage(
          curator: curationInfo.curator,
          imageWidth: AppDimens.avatarSize,
          imageHeight: AppDimens.avatarSize,
          editorAvatar: AppVectorGraphics.editorialTeamAvatar,
        ),
        const SizedBox(width: AppDimens.s),
        Text(
          curationInfo.recommendedByText,
          style: AppTypography.b3Regular.copyWith(
            height: 1,
            letterSpacing: 0,
            color: AppColors.darkerGrey,
          ),
        ),
      ],
    );
  }
}

extension on ArticleCurationInfo {
  String get recommendedByText {
    return '$byline $_name';
  }

  String get _name {
    if (curator is Editor) {
      return curator.name;
    } else if (curator is Expert) {
      return curator.name;
    } else if (curator is EditorialTeam) {
      return curator.name;
    } else {
      return "";
    }
  }
}
