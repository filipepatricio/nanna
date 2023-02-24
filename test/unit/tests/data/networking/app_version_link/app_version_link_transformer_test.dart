import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link_transformer.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late MockAppInfoDataSource appInfoDataSource;
  late AppVersionLinkTransformer appVersionLinkTransformer;

  setUp(() {
    appInfoDataSource = MockAppInfoDataSource();
    appVersionLinkTransformer = AppVersionLinkTransformer(appInfoDataSource);
  });

  test('returns request with correct $appVersionHeaderKey header', () async {
    /// Case 1

    final originalRequest1 = Request(
      operation: Operation(
        document: gql(''),
      ),
    );
    const appName1 = 'informed';
    const appVersion1 = '1.0.0';
    const expectedHeader1 = 'informed:1.0.0';

    when(appInfoDataSource.getAppName()).thenAnswer((realInvocation) async => appName1);
    when(appInfoDataSource.getAppVersion()).thenAnswer((realInvocation) async => appVersion1);

    final transformedRequest1 = await appVersionLinkTransformer(originalRequest1);

    final transformedHeaders1 = transformedRequest1.context.entry<HttpLinkHeaders>();
    expect(transformedHeaders1, isNotNull);
    expect(transformedHeaders1!.headers[appVersionHeaderKey], expectedHeader1);

    /// Case 2

    final originalRequest2 = Request(
      operation: Operation(
        document: gql(''),
      ),
    );
    const appName2 = 'informed dev';
    const appVersion2 = '0.1.1';
    const expectedHeader2 = 'informed dev:0.1.1';

    when(appInfoDataSource.getAppName()).thenAnswer((realInvocation) async => appName2);
    when(appInfoDataSource.getAppVersion()).thenAnswer((realInvocation) async => appVersion2);

    final transformedRequest2 = await appVersionLinkTransformer(originalRequest2);

    final transformedHeaders2 = transformedRequest2.context.entry<HttpLinkHeaders>();
    expect(transformedHeaders2, isNotNull);
    expect(transformedHeaders2!.headers[appVersionHeaderKey], expectedHeader2);
  });

  group('returns request with $appVersionHeaderKey', () {
    test('when original request does not have any headers', () async {
      final originalRequest = Request(
        operation: Operation(
          document: gql(''),
        ),
      );
      final expectedHeaders = {appVersionHeaderKey: 'informed:0.0.1'};

      when(appInfoDataSource.getAppName()).thenAnswer((realInvocation) async => 'informed');
      when(appInfoDataSource.getAppVersion()).thenAnswer((realInvocation) async => '0.0.1');

      final transformedRequest = await appVersionLinkTransformer(originalRequest);

      final transformedContext = transformedRequest.context.entry<HttpLinkHeaders>();
      expect(transformedContext, isNotNull);
      expect(transformedContext!.headers, expectedHeaders);
    });

    test('when original request already contains other headers', () async {
      final originalHeaders = {
        'Authorization': 'Bearer abc-000-abc-111',
      };
      final originalRequest = Request(
        operation: Operation(
          document: gql(''),
        ),
        context: Context.fromList(
          [
            HttpLinkHeaders(headers: originalHeaders),
          ],
        ),
      );
      final expectedHeaders = Map.of(originalHeaders)
        ..addAll(
          {
            appVersionHeaderKey: 'informed:0.0.1',
          },
        );

      when(appInfoDataSource.getAppName()).thenAnswer((realInvocation) async => 'informed');
      when(appInfoDataSource.getAppVersion()).thenAnswer((realInvocation) async => '0.0.1');

      final transformedRequest = await appVersionLinkTransformer(originalRequest);

      final transformedContext = transformedRequest.context.entry<HttpLinkHeaders>();
      expect(transformedContext, isNotNull);
      expect(transformedContext!.headers, expectedHeaders);
    });
  });
}
