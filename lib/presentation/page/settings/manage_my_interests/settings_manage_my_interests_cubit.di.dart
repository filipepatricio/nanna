import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_category_preferences_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const _briefNotifierDebounceDuration = Duration(seconds: 5);

@injectable
class SettingsManageMyInterestsCubit extends Cubit<SettingsManageMyInterestsState> {
  SettingsManageMyInterestsCubit(
    this._getCategoryPreferencesUseCase,
    this._updateBriefNotifierUseCase,
  ) : super(const SettingsManageMyInterestsState.loading());

  final GetCategoryPreferencesUseCase _getCategoryPreferencesUseCase;
  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;

  final StreamController<bool> _updateBriefStreamController = StreamController();
  StreamSubscription? _shouldNotifyBriefUpdateSubscription;

  @override
  Future<void> close() async {
    _updateBriefNotifierUseCase();
    await _shouldNotifyBriefUpdateSubscription?.cancel();
    await _updateBriefStreamController.close();
    await super.close();
  }

  Future<void> initialize() async {
    emit(const SettingsManageMyInterestsState.loading());

    await _shouldNotifyBriefUpdateSubscription?.cancel();
    _shouldNotifyBriefUpdateSubscription = _updateBriefStreamController.stream
        .debounceTime(_briefNotifierDebounceDuration)
        .listen((_) => _updateBriefNotifierUseCase());

    try {
      final categoryPreferences = await _getCategoryPreferencesUseCase();
      emit(SettingsManageMyInterestsState.myInterestsSettingsLoaded(categoryPreferences));
    } on NoInternetConnectionException {
      emit(
        SettingsManageMyInterestsState.error(
          LocaleKeys.noConnection_error_title.tr(),
          LocaleKeys.noConnection_error_message.tr(),
        ),
      );
    } catch (e, s) {
      emit(
        SettingsManageMyInterestsState.error(
          LocaleKeys.common_error_title.tr(),
          LocaleKeys.common_error_body.tr(),
        ),
      );
      Fimber.e('Getting categories preferences failed', ex: e, stacktrace: s);
    }
  }
}
