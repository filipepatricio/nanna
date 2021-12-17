import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

enum ShareArticleButtonState { idle, processing }

@injectable
class ShareArticleButtonCubit extends Cubit<ShareArticleButtonState> {
  ShareArticleButtonCubit() : super(ShareArticleButtonState.idle);

  Future<void> share(MediaItemArticle article) async {
    emit(ShareArticleButtonState.processing);

    final generator = ShareViewImageGenerator(
      () => ShareArticleView(
        article: article,
      ),
    );

    await shareImage(
      generator,
      '${article.id}_share_article.png',
      article.strippedTitle,
    );

    emit(ShareArticleButtonState.idle);
  }
}
