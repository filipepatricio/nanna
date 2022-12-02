import 'dart:io';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_content.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_options.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_content_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_background_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum ShareArticleButtonState { idle, processing, showMessage }

@injectable
class ShareArticleButtonCubit extends Cubit<ShareArticleButtonState> {
  ShareArticleButtonCubit(
    this._shareViewImageGenerator,
    this._shareContentUseCase,
    this._trackActivityUseCase,
  ) : super(ShareArticleButtonState.idle);

  final ShareViewImageGenerator _shareViewImageGenerator;
  final ShareContentUseCase _shareContentUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  Future<void> share(ShareOption? shareOption, MediaItemArticle article) async {
    if (shareOption == null) return;

    emit(ShareArticleButtonState.processing);

    ShareContent shareContent;

    switch (shareOption) {
      case ShareOption.instagram:
        final images = await Future.wait(
          [
            _generateForegroundImage(article),
            _generateBackgroundImage(article),
          ],
        );

        shareContent = ShareContent.instagram(
          images[0],
          images[1],
          article.url,
        );
        break;
      case ShareOption.facebook:
        shareContent = ShareContent.facebook(
          await _generateCombinedImage(article),
          article.url,
        );
        break;
      case ShareOption.copyLink:
        shareContent = ShareContent.text(
          shareOption,
          article.url,
          article.strippedTitle,
        );
        emit(ShareArticleButtonState.showMessage);
        break;
      default:
        shareContent = ShareContent.text(
          shareOption,
          article.url,
          article.strippedTitle,
        );
        break;
    }

    await _shareContentUseCase(shareContent);
    _trackActivityUseCase.trackEvent(AnalyticsEvent.articleShared(article.id));

    emit(ShareArticleButtonState.idle);
  }

  Future<File> _generateForegroundImage(MediaItemArticle article) async {
    ShareArticleStickerView factory() => ShareArticleStickerView(article: article);

    return generateShareImage(
      _shareViewImageGenerator,
      factory,
      '${article.id}_sticker_article.png',
    );
  }

  Future<File> _generateBackgroundImage(MediaItemArticle article) async {
    ShareArticleBackgroundView factoryEmptyImage() => ShareArticleBackgroundView(article: article);

    return generateShareImage(
      _shareViewImageGenerator,
      factoryEmptyImage,
      '${article.id}_background_article.png',
    );
  }

  Future<File> _generateCombinedImage(MediaItemArticle article) async {
    ShareArticleCombinedView factoryEmptyImage() => ShareArticleCombinedView(article: article);

    return generateShareImage(
      _shareViewImageGenerator,
      factoryEmptyImage,
      '${article.id}_combined_article.png',
    );
  }
}
