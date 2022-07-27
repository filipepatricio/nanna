import 'dart:io';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_text_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_facebook_use_case.di.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_using_instagram_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/empty_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum ShareArticleButtonState { idle, processing, showMessage }

@injectable
class ShareArticleButtonCubit extends Cubit<ShareArticleButtonState> {
  ShareArticleButtonCubit(
    this._shareViewImageGenerator,
    this._shareTextUseCase,
    this._shareUsingInstagramUseCase,
    this._shareUsingFacebookUseCasel,
  ) : super(ShareArticleButtonState.idle);

  final ShareTextUseCase _shareTextUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;
  final ShareUsingInstagramUseCase _shareUsingInstagramUseCase;
  final ShareUsingFacebookUseCase _shareUsingFacebookUseCasel;

  Future<void> share(ShareOptions? shareOption, MediaItemArticle article) async {
    if (shareOption == null) return;

    emit(ShareArticleButtonState.processing);

    late File image;
    late File emptyImage;

    if (shareOption == ShareOptions.instagram || shareOption == ShareOptions.facebook) {
      ShareArticleView factory() => ShareArticleView(article: article);
      EmptyView factoryEmptyImage() => EmptyView();

      emptyImage = await generateShareImage(
        _shareViewImageGenerator,
        factoryEmptyImage,
        'empty_image.png',
      );

      image = await generateShareImage(
        _shareViewImageGenerator,
        factory,
        '${article.id}_share_article.png',
      );
    }
    switch (shareOption) {
      case ShareOptions.instagram:
        await _shareUsingInstagramUseCase(emptyImage, image, article.url);
        break;
      case ShareOptions.facebook:
        await _shareUsingFacebookUseCasel(image, article.url);
        break;
      case ShareOptions.copyLink:
        await _shareTextUseCase(shareOption, article.url, article.strippedTitle);
        emit(ShareArticleButtonState.showMessage);
        break;
      default:
        await _shareTextUseCase(shareOption, article.url, article.strippedTitle);
        break;
    }

    emit(ShareArticleButtonState.idle);
  }
}
