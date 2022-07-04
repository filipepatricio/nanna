import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/other_brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

class PremiumArticleOtherBriefSection extends StatelessWidget {
  const PremiumArticleOtherBriefSection({
    required this.otherBrief,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final List<OtherBriefEntryItem> otherBrief;
  final MediaItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.all(AppDimens.l),
          child: Text(
            LocaleKeys.article_otherBriefs.tr(),
            style: AppTypography.h1ExtraBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: otherBrief.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, _) => const Divider(height: AppDimens.xl),
            itemBuilder: (context, index) => otherBrief[index].map(
              article: (data) => _Article(
                briefArticle: data,
                cubit: cubit,
              ),
              topicPreview: (data) => _Topic(
                briefTopic: data,
                cubit: cubit,
              ),
              unknown: (_) => const SizedBox.shrink(),
            ),
          ),
        ),
        SizedBox(
          height: kBottomNavigationBarHeight * 2 + MediaQuery.of(context).padding.bottom,
        ),
      ],
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({required this.briefArticle, required this.cubit, Key? key}) : super(key: key);

  final OtherBriefEntryItemArticle briefArticle;
  final MediaItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return briefArticle.article == null
        ? const SizedBox.shrink()
        : Opacity(
            opacity: briefArticle.progressState == ArticleProgressState.finished ? 0.30 : 1,
            child: ArticleCover.otherBrief(
              article: briefArticle.article!,
              onTap: () => _navigateToArticle(
                context: context,
                article: briefArticle.article!,
                cubit: cubit,
              ),
            ),
          );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({required this.briefTopic, required this.cubit, Key? key}) : super(key: key);

  final OtherBriefEntryItemTopic briefTopic;
  final MediaItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return briefTopic.topic == null
        ? const SizedBox.shrink()
        : Opacity(
            opacity: briefTopic.visited ? 0.30 : 1,
            child: TopicCover.otherBrief(
              topic: briefTopic.topic!.asPreview,
              onTap: () => _navigateToTopic(
                context: context,
                topic: briefTopic.topic!,
                cubit: cubit,
              ),
            ),
          );
  }
}

void _navigateToArticle({
  required BuildContext context,
  required MediaItemArticle article,
  required MediaItemCubit cubit,
}) {
  AutoRouter.of(context).push(
    MediaItemPageRoute(
      article: article,
      briefId: cubit.briefId,
      topicId: cubit.topicId,
      slug: article.slug,
    ),
  );
}

void _navigateToTopic({
  required BuildContext context,
  required Topic topic,
  required MediaItemCubit cubit,
}) {
  AutoRouter.of(context).push(
    TopicPage(
      topicSlug: topic.slug,
      briefId: cubit.briefId,
      topic: topic,
    ),
  );
}
