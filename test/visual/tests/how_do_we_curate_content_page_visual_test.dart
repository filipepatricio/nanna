import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/how_do_we_curate_content_page.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(
    HowDoWeCurateContentPage,
    (tester) async {
      await tester.startApp(initialRoute: const HowDoWeCurateContentPageRoute());
      await tester.matchGoldenFile();
    },
  );
}
