import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/settings_subscription_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsSubscriptionPageCubit extends Cubit<SettingsSubscriptionPageState> {
  SettingsSubscriptionPageCubit(this._getActiveSubscriptionUseCase) : super(const SettingsSubscriptionPageState.init());

  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  Future<void> initialize() async {
    emit(const SettingsSubscriptionPageState.loading());

    final activeSubscription = await _getActiveSubscriptionUseCase();

    activeSubscription.mapOrNull(
      trial: (subscription) {
        emit(SettingsSubscriptionPageState.trial(subscription: subscription));
      },
      premium: (subscription) {
        emit(SettingsSubscriptionPageState.premium(subscription: subscription));
      },
      // TODO: INF-2008
    );
  }
}
