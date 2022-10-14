import 'package:better_informed_mobile/domain/article/data/publisher.dart';

class TopicPublisherInformation {
  TopicPublisherInformation({
    required this.highlightedPublishers,
    required this.remainingPublishersIndicator,
  });
  final List<Publisher> highlightedPublishers;
  final String? remainingPublishersIndicator;
}
