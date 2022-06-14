import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_actions_bar.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_view.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_cubit.di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'media item page has not premium audio view if article doesnt have audio version',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: ''),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PremiumArticleView), findsOneWidget);
      expect(find.byType(AudioButton), findsNothing);
      expect(find.byType(PremiumArticleAudioView), findsNothing);
    },
  );

  testWidgets(
    'media item page has premium audio view if article hasAudioVersion',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PremiumArticleView), findsOneWidget);
      expect(find.byType(AudioButton), findsOneWidget);
      await tester.tap(find.byType(AudioButton));
      await tester.pumpAndSettle();
      expect(find.byType(PremiumArticleAudioView), findsOneWidget);
    },
  );

  testWidgets(
    'pressing play button changes the state',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AudioButton), findsOneWidget);
      await tester.tap(find.byType(AudioButton));
      await tester.pumpAndSettle();

      final playButton = find.byType(AudioControlButton);
      expect(playButton, findsOneWidget);
      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: playButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.playArrow,
      );
      await tester.tap(playButton);
      await tester.pumpAndSettle();

      final pauseButton = find.byType(AudioControlButton);
      expect(pauseButton, findsOneWidget);
      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: playButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.pause,
      );
    },
  );

  testWidgets(
    'article is not bookmarked',
    (tester) async {
      final BookmarkButtonCubit cubit = FakeBookmarkButtonCubit();

      await tester.startApp(
        dependencyOverride: (getIt) async {
          getIt.registerFactory<BookmarkButtonCubit>(() => cubit);
        },
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      final bookmarkButton = find.descendant(
        of: find.byType(BookmarkButton),
        matching: find.byType(GestureDetector),
      );
      expect(bookmarkButton, findsOneWidget);

      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: bookmarkButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.heartUnselectedWhite,
      );
    },
  );

  testWidgets(
    'article is bookmarked',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            MediaItemPageRoute(slug: TestData.premiumArticleWithAudio.slug),
          ],
        ),
      );
      final bookmarkButton = find.descendant(
        of: find.byType(BookmarkButton),
        matching: find.byType(GestureDetector),
      );
      expect(bookmarkButton, findsOneWidget);

      expect(
        (tester
                .widget<SvgPicture>(
                  find.descendant(
                    of: bookmarkButton,
                    matching: find.byType(SvgPicture),
                  ),
                )
                .pictureProvider as ExactAssetPicture)
            .assetName,
        AppVectorGraphics.heartSelectedNoBorder,
      );
    },
  );
}
