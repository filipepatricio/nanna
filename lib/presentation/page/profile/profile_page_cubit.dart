import 'package:better_informed_mobile/domain/bookmark/data/bookmark_filter.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageState.idle(BookmarkFilter.all));

  Future<void> initialize() async {}

  Future<void> changeFilter(BookmarkFilter filter) async {
    emit(state.copyWith(filter: filter));
  }
}
