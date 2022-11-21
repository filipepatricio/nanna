import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/audio/audio_page.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${AudioPage}_(image)', (tester) async {
    final article = TestData.premiumArticleWithAudio;
    final audioFile = TestData.audioFile;

    await tester.startApp(
      initialRoute: AudioPageRoute(
        article: article,
        audioFile: audioFile,
      ),
    );

    await tester.matchGoldenFile();
  });

  visualTest('${AudioPage}_(no_image)', (tester) async {
    final article = TestData.premiumArticleWithAudioNoImage;
    final audioFile = TestData.audioFile;

    await tester.startApp(
      initialRoute: AudioPageRoute(
        article: article,
        audioFile: audioFile,
      ),
    );

    await tester.matchGoldenFile();
  });
}
