import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_preferable_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_preferred_categories_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/add_interests/add_interests_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddInterestsPageCubit extends Cubit<AddInterestsPageState> {
  AddInterestsPageCubit(
    this._getPreferableCategoriesUseCase,
    this._updatePreferredCategoriesUseCase,
    this._updateBriefNotifierUseCase,
  ) : super(AddInterestsPageState.loading());

  final GetPreferableCategoriesUseCase _getPreferableCategoriesUseCase;
  final UpdatePreferredCategoriesUseCase _updatePreferredCategoriesUseCase;
  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;

  Future<void> init() async {
    final categories = await _getPreferableCategoriesUseCase();
    emit(
      AddInterestsPageState.idle(
        categories: categories,
        selectedCategories: {},
      ),
    );
  }

  void selectCategory(Category category) {
    state.mapOrNull(
      idle: (state) {
        emit(
          state.copyWith(
            selectedCategories: {...state.selectedCategories, category},
          ),
        );
      },
    );
  }

  void unselectCategory(Category category) {
    state.mapOrNull(
      idle: (state) {
        final selected = state.selectedCategories.whereNot((element) => element == category).toSet();
        emit(
          state.copyWith(
            selectedCategories: selected,
          ),
        );
      },
    );
  }

  Future<void> apply() async {
    await state.mapOrNull(
      idle: (state) async {
        emit(
          AddInterestsPageState.processing(
            categories: state.categories,
            selectedCategories: state.selectedCategories,
          ),
        );

        try {
          await _updatePreferredCategoriesUseCase(state.selectedCategories.toList());
          _updateBriefNotifierUseCase();
          emit(AddInterestsPageState.success());
        } catch (e, s) {
          Fimber.e('Setting interests failed', ex: e, stacktrace: s);
          emit(AddInterestsPageState.failure());
          emit(
            AddInterestsPageState.idle(
              categories: state.categories,
              selectedCategories: state.selectedCategories,
            ),
          );
        }
      },
    );
  }
}
