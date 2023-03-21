import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/article_read_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/profile_bookmark_change_notifier.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_calendar_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_entry_seen_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/brief_entry_new_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/general/should_refresh_page_notifier.di.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:better_informed_mobile/domain/util/network_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOutUseCase {
  SignOutUseCase(
    this._authStore,
    this._analyticsRepository,
    this._pushNotificationStore,
    this._pushNotificationRepository,
    this._refreshTokenServiceCache,
    this._userStore,
    this._purchasesRepository,
    this._articleRepository,
    this._userLocalRepository,
    this._articleLocalRepository,
    this._topicsLocalRepository,
    this._bookmarkLocalRepository,
    this._articleProgressLocalRepository,
    this._dailyBriefLocalRepository,
    this._dailyBriefCalendarLocalRepository,
    this._dailyBriefItemSeenLocalRepository,
    this._networkCacheManager,
    this._getIt,
  );
  final AuthStore _authStore;
  final AnalyticsRepository _analyticsRepository;
  final PushNotificationStore _pushNotificationStore;
  final PushNotificationRepository _pushNotificationRepository;
  final RefreshTokenServiceCache _refreshTokenServiceCache;
  final UserStore _userStore;
  final PurchasesRepository _purchasesRepository;
  final ArticleRepository _articleRepository;
  final UserLocalRepository _userLocalRepository;
  final ArticleLocalRepository _articleLocalRepository;
  final TopicsLocalRepository _topicsLocalRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final ArticleProgressLocalRepository _articleProgressLocalRepository;
  final DailyBriefLocalRepository _dailyBriefLocalRepository;
  final DailyBriefCalendarLocalRepository _dailyBriefCalendarLocalRepository;
  final DailyBriefEntrySeenLocalRepository _dailyBriefItemSeenLocalRepository;

  final NetworkCacheManager _networkCacheManager;
  final GetIt _getIt;

  Future<void> call() async {
    _refreshTokenServiceCache.clear();
    _pushNotificationRepository.dispose();
    _purchasesRepository.dispose();
    _articleRepository.dispose();

    await _articleLocalRepository.deleteAll();
    await _topicsLocalRepository.deleteAll();
    await _bookmarkLocalRepository.deleteAll();
    await _articleProgressLocalRepository.deleteAll();
    await _dailyBriefLocalRepository.deleteAll();
    await _dailyBriefItemSeenLocalRepository.deleteAll();
    await _dailyBriefCalendarLocalRepository.clear();

    await _userLocalRepository.deleteUser();
    await _pushNotificationStore.clear();
    await _authStore.delete();
    await _userStore.clearCurrentUserUuid();
    await _analyticsRepository.logout();

    await _networkCacheManager.clear();

    _getIt.resetLazySingleton<ProfileBookmarkChangeNotifier>();
    _getIt.resetLazySingleton<ShouldRefreshPageNotifier>();
    _getIt.resetLazySingleton<BriefEntryNewStateNotifier>();
    _getIt.resetLazySingleton<ArticleReadStateNotifier>();
  }
}
