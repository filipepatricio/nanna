import 'package:better_informed_mobile/domain/util/use_case/get_app_version_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class VersionLabelCubit extends Cubit<String?> {
  VersionLabelCubit(this._getAppVersionUseCase) : super('');

  final GetAppVersionUseCase _getAppVersionUseCase;

  Future<void> initialize() async {
    final version = await _getAppVersionUseCase();
    emit(version);
  }
}
