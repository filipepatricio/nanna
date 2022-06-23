import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_foreground_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  const quote = 'Lorem Ipsum is simply dummy text of the printing'
      ' and typesetting industry. Lorem Ipsum has been'
      " the industry's standard dummy text ever.";

  visualTest(
    QuoteForegroundView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: QuoteForegroundView(
            quote: quote,
            quoteVariantData: quoteVariantDataList[0],
            article: TestData.article,
          ),
        ),
      );
      // By specifying the variant with a dot (.linen), the screens_report command will group all of them in a single image
      await tester.matchGoldenFile('quote_foreground_view.linen');

      final context = tester.element(find.byType(Container).first);
      final router = AutoRouter.of(context);

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteForegroundView(
              quote: quote,
              quoteVariantData: quoteVariantDataList[1],
              article: TestData.article,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_foreground_view.rose');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteForegroundView(
              quote: quote,
              quoteVariantData: quoteVariantDataList[2],
              article: TestData.article,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_foreground_view.green');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteForegroundView(
              quote: quote,
              quoteVariantData: quoteVariantDataList[3],
              article: TestData.article,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_foreground_view.peach');

      unawaited(
        router.replace(
          PlaceholderPageRoute(
            child: QuoteForegroundView(
              quote: quote,
              quoteVariantData: quoteVariantDataList[4],
              article: TestData.article,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.matchGoldenFile('quote_foreground_view.charcoal');
    },
    testConfig: TestConfig.stickerDevice(),
  );
}
