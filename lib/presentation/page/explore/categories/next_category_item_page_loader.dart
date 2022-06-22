import 'package:better_informed_mobile/domain/categories/use_case/get_category_use_case.di.dart';
import 'package:better_informed_mobile/domain/result_item/result_item.dt.dart';
import 'package:better_informed_mobile/presentation/util/pagination/pagination_engine.dart';

class NextCategoryItemPageLoader implements NextPageLoader<ResultItem> {
  final GetCategoryItemsUseCase _getCategoryItemsUseCase;
  final String slug;

  NextCategoryItemPageLoader(
    this._getCategoryItemsUseCase,
    this.slug,
  );

  @override
  Future<List<ResultItem>> call(NextPageConfig config) {
    return _getCategoryItemsUseCase(slug: slug, limit: config.limit, offset: config.offset);
  }
}
