import 'dart:async';

import 'package:better_informed_mobile/domain/legal_page/data/legal_page_type.dart';
import 'package:better_informed_mobile/domain/legal_page/use_case/get_privacy_policy_legal_page.di.dart';
import 'package:better_informed_mobile/domain/legal_page/use_case/get_terms_of_service_legal_page_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_legal_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsLegalPageCubit extends Cubit<SettingsLegalPageState> {
  SettingsLegalPageCubit(
    this._getPrivacyPolicyLegalPageUseCase,
    this._getTermsOfServiceLegalPageUseCase,
  ) : super(const SettingsLegalPageState.loading());

  final GetPrivacyPolicyLegalPageUseCase _getPrivacyPolicyLegalPageUseCase;
  final GetTermsOfServiceLegalPageUseCase _getTermsOfServiceLegalPageUseCase;

  Future<void> initialize(LegalPageType type) async {
    try {
      switch (type) {
        case LegalPageType.privacyPolicy:
          emit(SettingsLegalPageState.idle(await _getPrivacyPolicyLegalPageUseCase()));
          return;
        case LegalPageType.termsOfService:
          emit(SettingsLegalPageState.idle(await _getTermsOfServiceLegalPageUseCase()));
          return;
      }
    } catch (e, s) {
      emit(const SettingsLegalPageState.error());
      Fimber.e('Getting legal page $type failed', ex: e, stacktrace: s);
    }
  }
}
