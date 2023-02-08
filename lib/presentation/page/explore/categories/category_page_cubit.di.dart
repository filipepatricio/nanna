import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_category_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/category_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/categories/next_category_item_page_loader.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _paginationLimit = 10;

@injectable
class CategoryPageCubit extends Cubit<CategoryPageState> {
  CategoryPageCubit(
    this._getCategoryItemsUseCase,
    this._trackActivityUseCase,
  ) : super(CategoryPageState.loading());

  final GetCategoryItemsUseCase _getCategoryItemsUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  late NextCategoryItemPageLoader _nextCategoryItemPageLoader;
  late PaginationEngine<CategoryItem> _paginationEngine;
  late String _categorySlug;

  List<CategoryItem> _items = [];
  bool _allLoaded = false;

  Future<void> initialize(String categorySlug, List<CategoryItem> items) async {
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
        emit(
          CategoryPageState.error(
            LocaleKeys.noConnection_error_title.tr(),
            LocaleKeys.noConnection_error_message.tr(),
          ),
        );
      } catch (e, s) {
        emit(
          CategoryPageState.error(
            LocaleKeys.common_error_title.tr(),
            LocaleKeys.common_error_body.tr(),
          ),
        );
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
