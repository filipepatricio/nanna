import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_page.freezed.dart';

@freezed
class AnalyticsPage with _$AnalyticsPage {
  factory AnalyticsPage._(String name, [Map<String, dynamic>? properties]) = _AnalyticsPage;

  factory AnalyticsPage.onboarding(int index) => AnalyticsPage._('Onboarding', {'index': index});
}
