import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AudioView extends HookWidget {
  const AudioView({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final metadataStyle = AppTypography.systemText.copyWith(color: AppColors.textGrey, height: 1.12);
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppDimens.appBarHeight + AppDimens.m),
          Expanded(
            flex: 8,
            child: AspectRatio(
              aspectRatio: 0.60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ArticleListItem(
                    article: article,
                    themeColor: AppColors.background,
                    cardColor: AppColors.mockedColors[0],
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Text(
            article.title,
            style: AppTypography.h4Bold,
          ),
          const Spacer(),
          DottedArticleInfo(
            article: article,
            isLight: false,
            showLogo: false,
            fullDate: true,
            textStyle: metadataStyle,
            color: metadataStyle.color,
          ),
          const Spacer(flex: 10),
        ],
      ),
    );
  }
}
