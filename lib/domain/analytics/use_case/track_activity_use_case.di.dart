import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackActivityUseCase {
  final AnalyticsRepository _analyticsRepository;

  TrackActivityUseCase(this._analyticsRepository);

  void trackPage(AnalyticsPage page) {
    _analyticsRepository.page(page);
  }

  void trackEvent(AnalyticsEvent event) {
    _analyticsRepository.event(event);
  }
}
