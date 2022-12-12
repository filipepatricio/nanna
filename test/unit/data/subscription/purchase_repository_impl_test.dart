import 'package:better_informed_mobile/data/subscription/purchases_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../generated_mocks.mocks.dart';

const _premiumEntitlementId = 'premium';

void main() {
  late PurchasesRepositoryImpl repository;

  late MockAppConfig appConfig;
  late MockSubscriptionPlanMapper subscriptionPlanMapper;
  late MockActiveSubscriptionMapper activeSubscriptionMapper;
  late MockPurchaseRemoteDataSource purchaseRemoteDataSource;

  setUp(() {
    appConfig = MockAppConfig();
    subscriptionPlanMapper = MockSubscriptionPlanMapper();
    activeSubscriptionMapper = MockActiveSubscriptionMapper();
    purchaseRemoteDataSource = MockPurchaseRemoteDataSource();
    repository = PurchasesRepositoryImpl(
      appConfig,
      subscriptionPlanMapper,
      activeSubscriptionMapper,
      purchaseRemoteDataSource,
    );

    when(appConfig.revenueCatPremiumEntitlementId).thenReturn(_premiumEntitlementId);
  });

  group('initialize', () {
    test('should call configure on purchaseRemoteDataSource with', () async {
      when(appConfig.revenueCatKeyiOS).thenReturn('revenueCatKeyiOS');
      when(appConfig.revenueCatKeyAndroid).thenReturn('revenueCatKeyAndroid');
      when(purchaseRemoteDataSource.configure(any)).thenAnswer((_) async {});

      await repository.initialize();

      verify(purchaseRemoteDataSource.configure(any)).called(1);
    });
  });

  group('identify', () {
    const userId = 'userId';

    test('should call logIn and prefetch customer and offerings', () async {
      final logInResult = LogInResult(
        created: true,
        customerInfo: _customerInfo(),
      );

      when(purchaseRemoteDataSource.getCustomerInfo()).thenAnswer((_) async => _customerInfo());
      when(purchaseRemoteDataSource.getOfferings()).thenAnswer((_) async => const Offerings({}));
      when(purchaseRemoteDataSource.addCustomerInfoUpdateListener(any)).thenAnswer((_) async {});
      when(purchaseRemoteDataSource.logIn(userId)).thenAnswer((_) async => logInResult);

      await repository.identify(userId);

      verify(purchaseRemoteDataSource.logIn(userId)).called(1);
      verify(purchaseRemoteDataSource.getCustomerInfo()).called(1);
      verify(purchaseRemoteDataSource.getOfferings()).called(1);
      verify(purchaseRemoteDataSource.addCustomerInfoUpdateListener(any)).called(1);
    });
  });

  group('hasActiveSubscription', () {
    test('should return true if customerInfo has active entitlements', () async {
      when(purchaseRemoteDataSource.getCustomerInfo()).thenAnswer((_) async => _customerInfo());

      final result = await repository.hasActiveSubscription();

      expect(result, true);
    });

    test('should return false if customerInfo has no active entitlements', () async {
      when(purchaseRemoteDataSource.getCustomerInfo()).thenAnswer(
        (_) async => _customerInfo().copyWith(
          entitlements: const EntitlementInfos(
            {},
            {},
          ),
        ),
      );

      final result = await repository.hasActiveSubscription();

      expect(result, false);
    });
  });

  group('getActiveSubscription', () {
    test('should return premium subscription', () async {
      const package = Package(
        'packageId',
        PackageType.annual,
        StoreProduct(
          'identifier',
          'description',
          'title',
          10.0,
          '10.0',
          'EUR',
        ),
        currentOfferingKey,
      );

      const offerings = Offerings(
        {},
        current: Offering(
          currentOfferingKey,
          'serverDescription',
          [package],
        ),
      );

      final expected = ActiveSubscription.premium(
        DateTime.now(),
        'https://management-url.com',
        DateTime.now(),
        true,
        _createPlan(offeringId: currentOfferingKey, packageId: package.identifier),
        null,
      );

      when(purchaseRemoteDataSource.getOfferings()).thenAnswer((realInvocation) async => offerings);
      when(purchaseRemoteDataSource.getCustomerInfo()).thenAnswer((_) async => _customerInfo());
      when(activeSubscriptionMapper(any)).thenReturn(expected);

      final result = await repository.getActiveSubscription();

      expect(result, expected);
    });
  });

  group('purchase', () {
    test('should finish with success for current offering', () async {
      const package = Package(
        'packageId',
        PackageType.annual,
        StoreProduct(
          'identifier',
          'description',
          'title',
          10.0,
          '10.0',
          'EUR',
        ),
        currentOfferingKey,
      );

      const offerings = Offerings(
        {},
        current: Offering(
          currentOfferingKey,
          'serverDescription',
          [package],
        ),
      );

      when(purchaseRemoteDataSource.purchasePackage(package)).thenAnswer((_) async => _customerInfo());
      when(purchaseRemoteDataSource.getOfferings()).thenAnswer((realInvocation) async => offerings);

      final actual = await repository.purchase(_createPlan(offeringId: currentOfferingKey));

      expect(actual, true);
      verify(purchaseRemoteDataSource.purchasePackage(package)).called(1);
    });

    test('should finish with success for selected offering', () async {
      const offeringId = 'x-offering-id';
      const package = Package(
        'packageId',
        PackageType.annual,
        StoreProduct(
          'identifier',
          'description',
          'title',
          10.0,
          '10.0',
          'EUR',
        ),
        offeringId,
      );

      const offerings = Offerings(
        {
          offeringId: Offering(
            offeringId,
            'serverDescription',
            [package],
          ),
        },
      );

      when(purchaseRemoteDataSource.purchasePackage(package)).thenAnswer((_) async => _customerInfo());
      when(purchaseRemoteDataSource.getOfferings()).thenAnswer((realInvocation) async => offerings);

      final actual = await repository.purchase(_createPlan(offeringId: offeringId));

      expect(actual, true);
      verify(purchaseRemoteDataSource.purchasePackage(package)).called(1);
    });
  });
}

CustomerInfo _customerInfo() {
  return const CustomerInfo(
    _entitlements,
    {},
    [],
    [],
    [],
    '2022-01-01',
    'some-user-id',
    {},
    '2022-01-01',
    latestExpirationDate: '2022-01-01',
    originalPurchaseDate: '2022-01-01',
    originalApplicationVersion: '1.0.0',
    managementURL: 'https://management-url.com',
  );
}

const _entitlements = EntitlementInfos(
  {
    _premiumEntitlementId: EntitlementInfo(
      'abc',
      true,
      true,
      '2022-01-01',
      '2022-01-01',
      'abcc',
      false,
      ownershipType: OwnershipType.purchased,
      periodType: PeriodType.normal,
      store: Store.appStore,
    ),
  },
  {
    _premiumEntitlementId: EntitlementInfo(
      'abc',
      true,
      true,
      '2022-01-01',
      '2022-01-01',
      'abcc',
      false,
      ownershipType: OwnershipType.purchased,
      periodType: PeriodType.normal,
      store: Store.appStore,
    ),
  },
);

SubscriptionPlan _createPlan({String offeringId = 'offeringId', String packageId = 'packageId'}) {
  return SubscriptionPlan(
    type: SubscriptionPlanType.annual,
    description: 'Annual',
    price: 9.99,
    priceString: '9.99',
    title: 'Premium',
    trialDays: 0,
    reminderDays: 14,
    offeringId: offeringId,
    packageId: packageId,
    productId: 'productId',
  );
}
