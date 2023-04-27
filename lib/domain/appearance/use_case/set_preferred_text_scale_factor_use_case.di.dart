import 'package:better_informed_mobile/domain/appearance/appearance_preferences_store.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetPreferredArticleTextScaleFactorUseCase {
  SetPreferredArticleTextScaleFactorUseCase(
    this._appearancePreferencesStore,
    this._userStore,
  );

  final AppearancePreferencesStore _appearancePreferencesStore;
  final UserStore _userStore;

  Future<void> call(double textScaleFactor) async {
    final currentUserUuid = await _userStore.getCurrentUserUuid();
    return _appearancePreferencesStore.setPreferredArticleTextScaleFactor(currentUserUuid, textScaleFactor);
  }
}
