import 'package:better_informed_mobile/domain/search/use_case/search_content_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/search/search_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPageCubit extends Cubit<SearchPageState> {
  final SearchContentUseCase _searchContentUseCase;

  SearchPageCubit(
    this._searchContentUseCase,
  ) : super(SearchPageState.loading());

  Future<void> initialize() async {
    emit(SearchPageState.loading());
  }

  Future<void> search(String query, {int limit = 10, int offset = 0}) async {
    if (query.length < 3) {
      return;
    }
    final searchContent = await _searchContentUseCase.call(query, limit, offset);
    print(searchContent);
  }
}
