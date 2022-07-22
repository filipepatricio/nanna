import 'package:better_informed_mobile/domain/share/use_case/get_shareable_app_list_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/shareable_app/shareable_app_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareableAppCubit extends Cubit<ShareableAppState> {
  ShareableAppCubit(
    this._getShareableAppListUseCase,
  ) : super(const ShareableAppState.loading());

  final GetShareableAppListUseCase _getShareableAppListUseCase;

  Future<void> initialize() async {
    final apps = await _getShareableAppListUseCase();

    emit(ShareableAppState.idle(apps));
  }
}
