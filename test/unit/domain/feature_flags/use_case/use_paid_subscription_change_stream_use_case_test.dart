import 'package:better_informed_mobile/domain/feature_flags/use_case/use_paid_subscription_change_stream_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockFeaturesFlagsRepository featuresFlagsRepository;
  late MockNetworkCacheManager networkCacheManager;
  late UsePaidSubscriptionChangeStreamUseCase useCase;

  setUp(() {
    featuresFlagsRepository = MockFeaturesFlagsRepository();
    networkCacheManager = MockNetworkCacheManager();
    useCase = UsePaidSubscriptionChangeStreamUseCase(
      featuresFlagsRepository,
      networkCacheManager,
    );
  });

  test('emits new changed value', () async {
    final paidSubscriptionStreamValues = [
      false,
      false,
      true,
      false,
    ];
    final expectedStreamValues = [true, false];

    when(networkCacheManager.clear()).thenAnswer((realInvocation) async {});
    when(featuresFlagsRepository.usePaidSubscriptions()).thenAnswer((realInvocation) async => false);
    when(featuresFlagsRepository.usePaidSubscriptionStream()).thenAnswer(
      (realInvocation) => Stream.fromIterable(paidSubscriptionStreamValues),
    );

    expect(useCase(), emitsInOrder(expectedStreamValues));
  });

  test('does not emit anything when value does not change', () async {
    final paidSubscriptionStreamValues = [
      false,
      false,
      false,
      false,
    ];
    final expectedStreamValues = [];

    when(networkCacheManager.clear()).thenAnswer((realInvocation) async {});
    when(featuresFlagsRepository.usePaidSubscriptions()).thenAnswer((realInvocation) async => false);
    when(featuresFlagsRepository.usePaidSubscriptionStream()).thenAnswer(
      (realInvocation) => Stream.fromIterable(paidSubscriptionStreamValues),
    );

    expect(useCase(), emitsInOrder(expectedStreamValues));
  });
}
