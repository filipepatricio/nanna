import 'package:better_informed_mobile/domain/tutorial/tutorial_coach_mark_steps.dart';

extension TutorialCoachMarkStepExtention on TutorialCoachMarkStep {
  String get key {
    switch (this) {
      case TutorialCoachMarkStep.summaryCard:
        return 'TutorialCoachMarkStep_summaryCard';
      case TutorialCoachMarkStep.mediaItem:
        return 'TutorialCoachMarkStep_mediaItem';
    }
  }
}
