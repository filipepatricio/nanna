import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class ArticleWithCoverAreaLoadingView extends StatelessWidget {
  final Color color;
  final bool enabled;

  const ArticleWithCoverAreaLoadingView._({
    required this.color,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  const ArticleWithCoverAreaLoadingView.loading({Key? key})
      : this._(
          color: AppColors.pastelGreen,
          enabled: true,
          key: key,
        );

  const ArticleWithCoverAreaLoadingView.static({Key? key})
      : this._(
          color: AppColors.darkLinen,
          enabled: false,
          key: key,
        );

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
                child: LoadingShimmer(
                  mainColor: color,
                  enabled: enabled,
                  height: AppDimens.xl,
                ),
              ),
              const SizedBox(width: AppDimens.xxxc),
              LoadingShimmer(
                mainColor: color,
                enabled: enabled,
                height: AppDimens.xl,
                width: AppDimens.xl,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.l),
          child: LoadingShimmer(
            mainColor: color,
            enabled: enabled,
            height: AppDimens.exploreAreaFeaturedArticleHeight,
          ),
        ),
        const SizedBox(height: AppDimens.l),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            height: AppDimens.exploreAreaArticleListItemHeight,
            child: Row(
              children: [
                _ArticleItemShimmer(
                  color: color,
                  enabled: enabled,
                ),
                _ArticleItemShimmer(
                  color: color,
                  enabled: enabled,
                ),
                _ArticleItemShimmer(
                  color: color,
                  enabled: enabled,
                ),
                _ArticleItemShimmer(
                  color: color,
                  enabled: enabled,
                ),
                _ArticleItemShimmer(
                  color: color,
                  enabled: enabled,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleItemShimmer extends StatelessWidget {
  final Color color;
  final bool enabled;

  const _ArticleItemShimmer({
    required this.color,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      mainColor: color,
      enabled: enabled,
      padding: const EdgeInsets.only(left: AppDimens.l),
      height: AppDimens.exploreAreaArticleListItemHeight,
      width: AppDimens.exploreAreaArticleListItemWidth,
    );
  }
}
