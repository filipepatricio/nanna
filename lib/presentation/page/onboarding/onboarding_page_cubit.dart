import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;

  OnboardingPageCubit(this._requestNotificationPermissionUseCase) : super(OnboardingPageState.idle());

  Future<void> requestNotificationPermission() async {
    await _requestNotificationPermissionUseCase();
  }
}
