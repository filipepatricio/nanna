import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/article_type_label.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoCover extends StatelessWidget {
  final ArticleHeader article;

  const PhotoCover({required this.article});

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;
    return Container(
      width: AppDimens.articleItemWidth,
      height: MediaQuery.of(context).size.height * 0.52,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: imageId != null
                      ? Image.network(
                          CloudinaryImageExtension.withPublicId(imageId).transform().fit().generate()!,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
                if (article.type == ArticleType.premium) ...[
                  Positioned(
                    top: AppDimens.l,
                    left: AppDimens.l,
                    child: ArticleTypeLabel(article: article),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimens.m),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(article.publisher.name, style: AppTypography.metadata1Regular),
                  const Text(' · ', style: AppTypography.metadata1Regular),
                  Text(article.publicationDate, style: AppTypography.metadata1Regular),
                  const Text(' · ', style: AppTypography.metadata1Regular),
                  Text(
                    LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
                    style: AppTypography.metadata1Regular,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.s),
              Text(
                article.title,
                style: AppTypography.h2Bold,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ],
      ),
    );
  }
}
