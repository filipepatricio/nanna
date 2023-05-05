import 'package:better_informed_mobile/domain/appearance/use_case/get_preferred_text_scale_factor_use_case.di.dart';
import 'package:better_informed_mobile/domain/appearance/use_case/set_preferred_text_scale_factor_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_text_size_selector_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/appearance/settings_appearance_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SettingsAppearanceCubit extends Cubit<SettingsAppearanceState> {
  SettingsAppearanceCubit(
    this._getPreferredArticleTextScaleFactorUseCase,
    this._setPreferredArticleTextScaleFactorUseCase,
    this._shouldUseTextSizeSelectorUseCase,
  ) : super(const SettingsAppearanceState.init());

  final GetPreferredArticleTextScaleFactorUseCase _getPreferredArticleTextScaleFactorUseCase;
  final SetPreferredArticleTextScaleFactorUseCase _setPreferredArticleTextScaleFactorUseCase;
  final ShouldUseTextSizeSelectorUseCase _shouldUseTextSizeSelectorUseCase;

  Future<void> initialize() async {
    final showTextScaleFactorSelector = await _shouldUseTextSizeSelectorUseCase();
    final preferredTextScaleFactor = await _getPreferredArticleTextScaleFactorUseCase();

    emit(
      SettingsAppearanceState.idle(
        preferredArticleTextScaleFactor: preferredTextScaleFactor,
        showTextScaleFactorSelector: showTextScaleFactorSelector,
      ),
    );
  }

  Future<void> setPreferredArticleTextScaleFactor(double textScaleFactor) async {
    await _setPreferredArticleTextScaleFactorUseCase(textScaleFactor);
  }
}
