import 'package:better_informed_mobile/domain/share/use_case/get_share_options_list_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareOptionsCubit extends Cubit<ShareOptionsState> {
  ShareOptionsCubit(
    this._getShareOptionsListUseCase,
  ) : super(const ShareOptionsState.loading());

  final GetShareOptionsListUseCase _getShareOptionsListUseCase;

  Future<void> initialize() async {
    final apps = await _getShareOptionsListUseCase();

    emit(ShareOptionsState.idle(apps));
  }
}
