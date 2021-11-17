class HeroTag {
  static const dailyBriefTitle = 'daily-brief-title';
  static const dailyBriefRelaxPage = 'daily-brief-relax-page';

  static String dailyBriefTopicTitle(String id) => 'daily-brief-topic-title-$id';

  static String dailyBriefTopicAuthor(String id) => 'daily-brief-topic-author-$id';

  static String dailyBriefTopicSummary(String id) => 'daily-brief-topic-summary-$id';

  static String exploreArticleTitle(int id) => 'explore-article-title-$id';

  static String exploreTopicsTitle(int id) => 'explore-topics-title-$id';
}
