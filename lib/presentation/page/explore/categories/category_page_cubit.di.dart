import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_category_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/next_category_item_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class CategoryPageCubit extends Cubit<CategoryPageState> {
  CategoryPageCubit(
    this._getCategoryItemsUseCase,
    this._trackActivityUseCase,
    this._isGuestModeUseCase,
  ) : super(CategoryPageState.loading());

  final GetCategoryItemsUseCase _getCategoryItemsUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final IsGuestModeUseCase _isGuestModeUseCase;

  late NextCategoryItemPageLoader _nextCategoryItemPageLoader;
  late PaginationEngine<CategoryItem> _paginationEngine;
  late String _categorySlug;

  List<CategoryItem> _items = [];
  bool _allLoaded = false;

  Future<void> initialize(String categorySlug, List<CategoryItem> items) async {
    if (await _isGuestModeUseCase()) {
      emit(const CategoryPageState.guest());
      return;
    }

    _categorySlug = categorySlug;
    _nextCategoryItemPageLoader = NextCategoryItemPageLoader(_getCategoryItemsUseCase, _categorySlug);
    _paginationEngine = PaginationEngine(_nextCategoryItemPageLoader);
    if (items.isNotEmpty) {
      _items = items;
      _paginationEngine.initialize(items);
      emit(CategoryPageState.withPagination(items));
      _trackActivityUseCase.trackEvent(AnalyticsEvent.categoryPageScrolled(categorySlug, 0));
    } else {
      try {
        await loadNextPage();
      } on NoInternetConnectionException {
        emit(const CategoryPageState.offline());
      } catch (e, s) {
        emit(const CategoryPageState.error());
        Fimber.e('Querying category page failed', ex: e, stacktrace: s);
      }
    }
  }

  Future<void> loadNextPage() async {
    if (_isInLoadingState() || _allLoaded) return;

    emit(CategoryPageState.loadingMore(_items));

    _trackActivityUseCase.trackEvent(AnalyticsEvent.categoryPageScrolled(_categorySlug, _items.length));

    final limit = _items.length.isEven ? _paginationLimit : _paginationLimit - 1;
    final result = await _paginationEngine.loadMore(limitOverride: limit);

    _items = result.data;
    _allLoaded = result.allLoaded;

    if (_allLoaded) {
      emit(CategoryPageState.allLoaded(_items));
    } else {
      emit(CategoryPageState.withPagination(_items));
    }
  }

  bool _isInLoadingState() => state.maybeMap(
        loadingMore: (_) => true,
        orElse: () => false,
      );
}
