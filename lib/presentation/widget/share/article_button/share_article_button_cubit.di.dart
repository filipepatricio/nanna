import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_image_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.di.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum ShareArticleButtonState { idle, processing }

@injectable
class ShareArticleButtonCubit extends Cubit<ShareArticleButtonState> {
  ShareArticleButtonCubit(
    this._shareImageUseCase,
    this._shareViewImageGenerator,
  ) : super(ShareArticleButtonState.idle);

  final ShareImageUseCase _shareImageUseCase;
  final ShareViewImageGenerator _shareViewImageGenerator;

  Future<void> share(MediaItemArticle article) async {
    emit(ShareArticleButtonState.processing);

    ShareArticleView factory() => ShareArticleView(article: article);

    final image = await generateShareImage(
      _shareViewImageGenerator,
      factory,
      '${article.id}_share_article.png',
    );
    await _shareImageUseCase(
      image,
      article.url,
      article.strippedTitle,
    );

    emit(ShareArticleButtonState.idle);
  }
}
