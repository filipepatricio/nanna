import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_view.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'visual_test_utils.dart';

final _stickerDevice = TestConfig.unitTesting.withDevices(
  const [
    Device(
      size: Size(720, 1280),
      name: 'sticker_720x1280',
    ),
  ],
);

void main() {
  final articleMock = MediaItem.article(
    id: 'id',
    slug: 'slug',
    url: '',
    title: 'How golden tests changed my life',
    strippedTitle: 'How golden tests changed my life',
    type: ArticleType.premium,
    timeToRead: 0,
    publisher: Publisher(darkLogo: null, lightLogo: null, name: 'New York Times'),
    sourceUrl: 'sourceUrl',
    author: 'John Adams',
    image: Image(publicId: 'id'),
  ) as MediaItemArticle;

  const quote = 'Lorem Ipsum is simply dummy text of the printing'
      ' and typesetting industry. Lorem Ipsum has been'
      " the industry's standard dummy text ever.";

  visualTest(
    QuoteViewSticker,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: QuoteViewSticker(
            quote: quote,
            quoteVariantData: quoteVariantDataList[0],
            article: articleMock,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_view_sticker_linen');

      final context = tester.element(find.byType(Container).first);
      final router = AutoRouter.of(context);

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteViewSticker(
              quote: quote,
              quoteVariantData: quoteVariantDataList[1],
              article: articleMock,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_view_sticker_rose');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteViewSticker(
              quote: quote,
              quoteVariantData: quoteVariantDataList[2],
              article: articleMock,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_view_sticker_green');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteViewSticker(
              quote: quote,
              quoteVariantData: quoteVariantDataList[3],
              article: articleMock,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_view_sticker_peach');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteViewSticker(
              quote: quote,
              quoteVariantData: quoteVariantDataList[4],
              article: articleMock,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_view_sticker_charcoal');
    },
    testConfig: _stickerDevice,
  );
}
