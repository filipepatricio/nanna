enum TutorialCoachMarkStep { summaryCard, mediaItem }

extension TutorialCoachMarkStepExtention on TutorialCoachMarkStep {
  String get key {
    switch (this) {
      case TutorialCoachMarkStep.summaryCard:
        return 'summaryCard';
      case TutorialCoachMarkStep.mediaItem:
        return 'mediaItem';
    }
  }
}
