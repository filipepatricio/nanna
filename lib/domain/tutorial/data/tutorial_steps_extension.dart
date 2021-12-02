import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';

extension TutorialStepExtention on TutorialStep {
  String get key {
    switch (this) {
      case TutorialStep.todaysTopics:
        return 'TutorialStep_todaysTopics';
      case TutorialStep.topic:
        return 'TutorialStep_topic';
      case TutorialStep.topicSummaryCard:
        return 'TutorialStep_topicSummaryCard';
      case TutorialStep.topicMediaItem:
        return 'TutorialStep_topicMediaItem';
      case TutorialStep.explore:
        return 'TutorialStep_explore';
    }
  }
}
