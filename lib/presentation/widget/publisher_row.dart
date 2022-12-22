import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';

class PublisherRow extends StatelessWidget {
  const PublisherRow({
    required this.article,
    super.key,
  });

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (article.type == ArticleType.premium)
          PublisherLogo.dark(
            publisher: article.publisher,
            dimension: AppDimens.ml,
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.s),
            child: InformedSvg(
              AppVectorGraphics.arrowExternal,
              width: AppDimens.l,
              height: AppDimens.l,
              color: AppColors.of(context).textSecondary,
            ),
          ),
        Expanded(
          child: Text(
            article.publisher.name,
            maxLines: 1,
            style: AppTypography.b3Regular.copyWith(
              color: AppColors.of(context).textSecondary,
              height: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
