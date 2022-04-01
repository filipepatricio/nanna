import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/owner/widgets/last_updated_topics.dart';
import 'package:better_informed_mobile/presentation/widget/round_topic_cover/round_topic_cover_large.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'unknown owner avatar in topic cover',
    (tester) async {
      await tester.startApp();
      await tester.fling(find.byType(RoundTopicCoverLarge).first, const Offset(0, -10000), 100);
      await tester.pumpAndSettle();
      expect(find.byType(UnknownOwnerAvatar, skipOffstage: false), findsOneWidget);
    },
  );

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
      expect(find.byType(UnknownOwnerAvatar), findsOneWidget);
    },
  );

  testWidgets(
    'topic owner page fetches 0 editor topics for editor type',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            TopicOwnerPageRoute(owner: TestData.topicWithEditorOwner.owner),
          ],
        ),
      );
      await tester.pumpAndSettle();
      // Because [TopicsMockDataSource] returns 0 topics for editor and 2 for expert
      expect(find.byType(LastUpdatedTopics), findsNothing);
    },
    skip: true,
  );

  testWidgets(
    'topic owner page fetches 2 expert topics for expert type',
    (tester) async {
      await tester.startApp(
        initialRoute: MainPageRoute(
          children: [
            TopicOwnerPageRoute(owner: TestData.topic.owner),
          ],
        ),
      );
      expect(find.byType(LastUpdatedTopics), findsOneWidget);
    },
  );
}
