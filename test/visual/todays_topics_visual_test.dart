import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';

import '../test_data_creators.dart';
import 'visual_test_utils.dart';

void main() {
  visualTest(TodaysTopicsPage, TestConfig.unitTesting, (tester, device) async {
    await tester.startApp(currentUser: anUser());
    await matchGoldenFile();
    //TODO: remove skip flag when Network Images are completely mocked
  }, skip: true);
}
