import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/widgets/owner_topics.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curator_avatar_unknown.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_data.dart';
import '../../unit_test_utils.dart';

void main() {
  testWidgets(
    'unknown owner avatar in topic page',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            TopicPage(topicSlug: TestData.topicWithUnknownOwner.slug),
          ],
        ),
      );
      expect(find.byType(CuratorAvatarUnknown, skipOffstage: false), findsOneWidget);
    },
  );

  testWidgets(
    'topic owner page fetches 0 editor topics for editor type',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            TopicOwnerPageRoute(owner: TestData.topicWithEditorOwner.curationInfo.curator),
          ],
        ),
      );
      expect(find.byType(OwnerTopics), findsNothing);
    },
  );

  testWidgets(
    'topic owner page fetches 2 expert topics for expert type',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            TopicOwnerPageRoute(owner: TestData.topic.curationInfo.curator),
          ],
        ),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is OwnerTopics && widget.topics.length == 2,
        ),
        findsOneWidget,
      );
    },
  );
}
