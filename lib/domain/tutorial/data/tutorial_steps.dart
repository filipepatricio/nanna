enum TutorialStep { todaysTopics, topic, topicSummaryCard, topicMediaItem, explore }

extension TutorialStepExtention on TutorialStep {
  String get key {
    switch (this) {
      case TutorialStep.todaysTopics:
        return 'todaysTopics';
      case TutorialStep.topic:
        return 'topic';
      case TutorialStep.topicSummaryCard:
        return 'topicSummaryCard';
      case TutorialStep.topicMediaItem:
        return 'topicMediaItem';
      case TutorialStep.explore:
        return 'explore';
    }
  }
}
