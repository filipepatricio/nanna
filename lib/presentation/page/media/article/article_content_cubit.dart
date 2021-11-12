import 'package:better_informed_mobile/presentation/page/media/article/article_content_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleContentCubit extends Cubit<ArticleContentState> {
  ArticleContentCubit() : super(ArticleContentState.loading());
}
