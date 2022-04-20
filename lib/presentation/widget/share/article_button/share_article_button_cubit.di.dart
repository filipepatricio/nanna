import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/use_case/share_image_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_util.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_view_image_generator.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

enum ShareArticleButtonState { idle, processing }

@injectable
class ShareArticleButtonCubit extends Cubit<ShareArticleButtonState> {
  ShareArticleButtonCubit(this._shareImageUseCase) : super(ShareArticleButtonState.idle);

  final ShareImageUseCase _shareImageUseCase;

  Future<void> share(MediaItemArticle article, GetIt getIt) async {
    emit(ShareArticleButtonState.processing);

    final generator = ShareViewImageGenerator(
      () => ShareArticleView(
        article: article,
        getIt: getIt,
      ),
    );
    final image = await generateShareImage(
      generator,
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
