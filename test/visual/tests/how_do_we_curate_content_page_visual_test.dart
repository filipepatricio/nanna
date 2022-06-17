import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/how_do_we_curate_content_page.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    HowDoWeCurateContentPage,
    (tester) async {
      await tester.startApp(initialRoute: TopicPage(topicSlug: ''));
      await tester.tap(find.byType(TopicOwnerAvatar).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byText(LocaleKeys.topic_howDoWeCurateContent_label.tr()));
      await tester.pumpAndSettle();

      await tester.matchGoldenFile();
    },
  );
}
