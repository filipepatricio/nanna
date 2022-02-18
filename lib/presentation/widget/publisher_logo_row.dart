import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PublisherLogoRow extends HookWidget {
  final Topic topic;
  final Brightness mode;

  const PublisherLogoRow({
    required this.topic,
    this.mode = Brightness.dark,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providers = topic.highlightedPublishers;
    return Row(
      children: [
        ...providers.map(
          (publisher) {
            return mode == Brightness.dark
                ? PublisherLogo.dark(publisher: publisher)
                : PublisherLogo.light(publisher: publisher);
          },
        ),
      ],
    );
  }
}
