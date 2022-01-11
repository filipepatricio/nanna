import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class ArticleWithCoverAreaLoadingView extends StatelessWidget {
  const ArticleWithCoverAreaLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xxxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: AppDimens.xl,
                  child: const LoadingShimmer(),
                ),
              ),
              const SizedBox(width: AppDimens.xxxc),
              Container(
                height: AppDimens.xl,
                width: AppDimens.xl,
                child: const LoadingShimmer(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l),
          child: Container(
            height: AppDimens.exploreAreaFeaturedArticleHeight,
            child: const LoadingShimmer(),
          ),
        ),
        const SizedBox(height: AppDimens.l),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            height: AppDimens.exploreAreaArticleListItemHeight,
            child: Row(
              children: const [
                _ArticleItemShimmer(),
                _ArticleItemShimmer(),
                _ArticleItemShimmer(),
                _ArticleItemShimmer(),
                _ArticleItemShimmer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleItemShimmer extends StatelessWidget {
  const _ArticleItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.l),
      child: Container(
        height: AppDimens.exploreAreaArticleListItemHeight,
        width: AppDimens.exploreAreaArticleListItemWidth,
        child: const LoadingShimmer(),
      ),
    );
  }
}
