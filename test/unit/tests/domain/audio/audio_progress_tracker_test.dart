import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/audio/audio_progress_tracker.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockAnalyticsRepository analyticsRepository;
  late AudioProgressTracker tracker;

  setUp(() {
    analyticsRepository = MockAnalyticsRepository();
    tracker = AudioProgressTracker(analyticsRepository);
  });

  test('it emits event only once after reaching progress ratio', () async {
    const duration = Duration(seconds: 100);
    final progressList = List.generate(10, (index) => Duration(seconds: 90 + index));
    const id = '0000';
    final event = AnalyticsEvent.listenedToArticleAudio(id);

    when(analyticsRepository.event(any)).thenAnswer((realInvocation) {});

    for (final progress in progressList) {
      tracker.track(id, progress, duration);
    }

    verify(analyticsRepository.event(event)).called(1);
  });
  test('it emits event after reaching progress ration with different id', () async {
    const duration = Duration(seconds: 100);
    final progressList = List.generate(100, (index) => Duration(seconds: index));
    const id = '0000';
    const newId = '0001';
    final event = AnalyticsEvent.listenedToArticleAudio(id);
    final newEvent = AnalyticsEvent.listenedToArticleAudio(newId);

    when(analyticsRepository.event(any)).thenAnswer((realInvocation) {});

    tracker.track(id, duration, duration);

    for (final progress in progressList) {
      tracker.track(newId, progress, duration);
    }

    verify(analyticsRepository.event(event)).called(1);
    verify(analyticsRepository.event(newEvent)).called(1);
  });
  test('it does not emit any event before reaching progress ratio', () async {
    const duration = Duration(seconds: 100);
    final progressList = List.generate(90, (index) => Duration(seconds: index));
    const id = '0000';

    when(analyticsRepository.event(any)).thenAnswer((realInvocation) {});

    for (final progress in progressList) {
      tracker.track(id, progress, duration);
    }

    verifyNever(analyticsRepository.event(any));
  });
  test('it emits event for same id twice when progress resets', () async {
    const duration = Duration(seconds: 100);
    final progressList = List.generate(100, (index) => Duration(seconds: index));
    const id = '0000';
    final event = AnalyticsEvent.listenedToArticleAudio(id);

    when(analyticsRepository.event(any)).thenAnswer((realInvocation) {});

    tracker.track(id, duration, duration);

    for (final progress in progressList) {
      tracker.track(id, progress, duration);
    }

    verify(analyticsRepository.event(event)).called(2);
  });
}
