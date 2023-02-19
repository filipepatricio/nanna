import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  late List<Widget> allNotes;

  visualTest(
    ArticleCover,
    (tester) async {
      await tester.startApp(
        initialRoute: placeholderRouteWrapper(
          padding: EdgeInsets.zero,
          children: allNotes,
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.autoHeight(),
  );

  visualTest(
    '${ArticleCover}_(offline)',
    (tester) async {
      final isInternetConnectionAvailableUseCase = MockIsInternetConnectionAvailableUseCase();
      when(isInternetConnectionAvailableUseCase.call()).thenAnswer((_) async => false);
      when(isInternetConnectionAvailableUseCase.stream).thenAnswer((_) => Stream.value(false));

      final loadLocalArticleUseCase = MockLoadLocalArticleUseCase();
      when(loadLocalArticleUseCase.call(any)).thenAnswer((_) async => null);

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<IsInternetConnectionAvailableUseCase>(
            () => isInternetConnectionAvailableUseCase,
          );
        },
        initialRoute: placeholderRouteWrapper(
          padding: EdgeInsets.zero,
          children: allNotes,
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.autoHeight(),
  );

  setUp(() {
    allNotes = [
      /// Large
      ArticleCover.large(
        article: TestData.article,
        onTap: () {},
      ),

      /// Large w/note
      ArticleCover.large(
        article: TestData.article,
        isNew: true,
        showNote: true,
        showRecommendedBy: true,
        onTap: () {},
      ),

      /// Large w/note collapsed
      ArticleCover.large(
        article: TestData.premiumArticleNoteCollapsible,
        isNew: true,
        showNote: true,
        showRecommendedBy: true,
        onTap: () {},
      ),

      /// Medium
      ArticleCover.medium(
        article: TestData.article,
        onTap: () {},
      ),

      /// Medium w/note
      ArticleCover.medium(
        article: TestData.article,
        isNew: true,
        showNote: true,
        showRecommendedBy: true,
        onTap: () {},
      ),

      /// Medium w/note collapsed
      ArticleCover.medium(
        article: TestData.premiumArticleNoteCollapsible,
        isNew: true,
        showNote: true,
        showRecommendedBy: true,
        onTap: () {},
      ),

      /// Small
      Builder(
        builder: (context) => SizedBox(
          width: MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor,
          child: ArticleCover.small(
            article: TestData.article,
            onTap: () {},
          ),
        ),
      ),
    ];
  });
}
