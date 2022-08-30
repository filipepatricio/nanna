import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_cover_audio_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_floating_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/visited_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleLabelsSection extends HookWidget {
  const ArticleLabelsSection({
    required this.article,
    required this.bookmarkButtonMode,
    required this.audioFloatingControlButtonMode,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final BookmarkButtonMode bookmarkButtonMode;
  final AudioFloatingControlButtonMode audioFloatingControlButtonMode;

  @override
  Widget build(BuildContext context) {
    final kind = article.kind;
    final shouldShowAudioButton = useMemoized(() => article.hasAudioVersion && !article.visited);
    return Row(
      children: [
        BookmarkButton.article(
          article: article,
          mode: bookmarkButtonMode,
          iconSize: AppDimens.l,
        ),
        const SizedBox(width: AppDimens.ml),
        if (kind != null) CoverLabel.articleKind(kind),
        const Spacer(),
        if (shouldShowAudioButton)
          ArticleCoverAudioButton(
            article: article,
            audioFloatingControlButtonMode: audioFloatingControlButtonMode,
          ),
        if (article.visited) const VisitedCheck()
      ],
    );
  }
}
