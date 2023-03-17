import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_brief_entry_new_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/brief_entry_cover/brief_entry_cover_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BriefEntryCoverCubit extends Cubit<BriefEntryCoverState> {
  BriefEntryCoverCubit(
    this._getBriefEntryNewStateStreamUseCase,
  ) : super(BriefEntryCoverState.initializing());

  final GetBriefEntryNewStateStreamUseCase _getBriefEntryNewStateStreamUseCase;

  late BriefEntry _entry;

  StreamSubscription? _shouldUpdateBriefEntryNewStateSubscription;

  @override
  Future<void> close() {
    _shouldUpdateBriefEntryNewStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize(BriefEntry entry) async {
    _entry = entry;
    emit(BriefEntryCoverState.idle(_entry));
    _shouldUpdateBriefEntryNewStateSubscription =
        _getBriefEntryNewStateStreamUseCase(_entry.slug).listen((updatedEntry) {
      _entry = _entry.copyWith(isNew: false);
      emit(BriefEntryCoverState.idle(_entry));
    });
  }
}
