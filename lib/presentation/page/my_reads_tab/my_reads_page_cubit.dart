import 'package:better_informed_mobile/presentation/page/my_reads_tab/my_reads_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyReadsPageCubit extends Cubit<MyReadsPageState> {
  MyReadsPageCubit() : super(MyReadsPageState.initialLoading());

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(MyReadsPageState.idle());
  }
}
