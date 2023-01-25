import 'package:better_informed_mobile/presentation/page/profile/bookmark_list_view/free_user_banner.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';

class BookmarkLoadingView extends StatelessWidget {
  const BookmarkLoadingView({
    this.hasActiveSubscription = true,
    super.key,
  });

  final bool hasActiveSubscription;

  @override
  Widget build(BuildContext context) {
    const cardHeight = 150.0;

    const separator = SizedBox(height: AppDimens.l);

    const tile = LoadingShimmer.defaultColor(
      width: double.infinity,
      height: cardHeight,
      radius: AppDimens.s,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const FreeUserBanner(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimens.xl),
              ...List.generate(10, (index) => [tile, separator]).expand(
                (couple) => couple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
