import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/other_brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

class PremiumArticleOtherBriefSection extends StatelessWidget {
  const PremiumArticleOtherBriefSection(this.otherBrief, {Key? key}) : super(key: key);

  final List<OtherBriefEntryItem> otherBrief;

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
              article: (data) => _Article(data),
              topicPreview: (data) => _Topic(data),
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
  const _Article(this.briefArticle, {Key? key}) : super(key: key);

  final OtherBriefEntryItemArticle briefArticle;

  @override
  Widget build(BuildContext context) {
    return briefArticle.article == null
        ? const SizedBox.shrink()
        : Opacity(
            opacity: briefArticle.progressState == ArticleProgressState.finished ? 0.30 : 1,
            child: ArticleCover.otherBrief(
              article: briefArticle.article!,
              onTap: () => _navigateToArticle(
                context,
                briefArticle.article!,
              ),
            ),
          );
  }
}

class _Topic extends StatelessWidget {
  const _Topic(this.briefTopic, {Key? key}) : super(key: key);

  final OtherBriefEntryItemTopic briefTopic;

  @override
  Widget build(BuildContext context) {
    return briefTopic.topic == null
        ? const SizedBox.shrink()
        : Opacity(
            opacity: briefTopic.visited ? 0.30 : 1,
            child: TopicCover.otherBrief(
              topic: briefTopic.topic!.asPreview,
              onTap: () => _navigateToTopic(
                context,
                briefTopic.topic!.slug,
              ),
            ),
          );
  }
}

void _navigateToArticle(BuildContext context, MediaItemArticle article) {
  AutoRouter.of(context).push(MediaItemPageRoute(article: article));
}

void _navigateToTopic(BuildContext context, String topicSlug) {
  AutoRouter.of(context).push(TopicPage(topicSlug: topicSlug));
}
