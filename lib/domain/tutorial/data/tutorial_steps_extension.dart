import 'package:better_informed_mobile/domain/tutorial/tutorial_steps.dart';

extension TutorialStepExtention on TutorialStep {
  String get key {
    switch (this) {
      case TutorialStep.dailyBrief:
        return 'TutorialStep_dailyBrief';
      case TutorialStep.topic:
        return 'TutorialStep_topic';
      case TutorialStep.dailyBriefTopicCard:
        return 'TutorialStep_dailyBriefTopicCard';
      case TutorialStep.topicMediaItem:
        return 'TutorialStep_topicMediaItem';
      case TutorialStep.explore:
        return 'TutorialStep_explore';
      case TutorialStep.profile:
        return 'TutorialStep_profile';
    }
  }
}
