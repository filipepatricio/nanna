import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/content/topic_cover_content.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum TopicCoverSize { small, large }

class TopicCover extends HookWidget {
  const TopicCover._({
    required this.topic,
    required this.size,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverSize size;

  factory TopicCover.large({required TopicPreview topic}) => TopicCover._(
        size: TopicCoverSize.large,
        topic: topic,
      );

  factory TopicCover.small({required TopicPreview topic}) => TopicCover._(
        size: TopicCoverSize.small,
        topic: topic,
      );

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicCoverCubit>();
    final state = useCubitBuilder<TopicCoverCubit, TopicCoverState>(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimens.m),
        ),
      ),
      child: Stack(
        children: state.map(
          idle: (data) => [
            TopicCoverImage(
              topic: topic,
              showPhoto: data.showPhoto,
            ),
            TopicCoverContent(
              topic: topic,
              size: size,
              mode: data.showPhoto ? Brightness.light : Brightness.dark,
            ),
          ],
          loading: (_) => [
            TopicCoverContent(
              topic: topic,
              size: size,
            ),
          ],
        ),
      ),
    );
  }
}
