import 'package:better_informed_mobile/domain/my_reads/use_case/get_my_reads_content_use_case.dart';
import 'package:better_informed_mobile/presentation/page/my_reads_tab/my_reads_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyReadsPageCubit extends Cubit<MyReadsPageState> {
  final GetMyReadsContentUseCase _getMyReadsContentUseCase;

  MyReadsPageCubit(this._getMyReadsContentUseCase) : super(MyReadsPageState.initialLoading());

  Future<void> initialize() async {
    final content = await _getMyReadsContentUseCase();
    emit(MyReadsPageState.idle(content));
  }
}
