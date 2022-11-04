import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';

extension DailyBriefTutorialCoachMarkStepExtention on DailyBriefPageTutorialCoachMarkStep {
  String get key {
    switch (this) {
      case DailyBriefPageTutorialCoachMarkStep.topicCard:
        return 'DailyBriefTutorialCoachMarkStep_topicCard';
    }
  }
}
