import 'package:better_informed_mobile/domain/my_reads/data/my_reads_content.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_reads_page_state.freezed.dart';

@freezed
class MyReadsPageState with _$MyReadsPageState {
  @Implements(BuildState)
  factory MyReadsPageState.initialLoading() = _MyReadsPageStateInitialLoading;

  @Implements(BuildState)
  factory MyReadsPageState.idle(MyReadsContent content) = _MyReadsPageStateIdle;
}
