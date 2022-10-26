import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/call_to_action.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

part 'widgets/relax_article_content.dart';
part 'widgets/relax_daily_brief_content.dart';

enum RelaxViewType { dailyBrief, article }

const _iconSize = 54.0;

class RelaxView extends StatelessWidget {
  const RelaxView._({
    required this.type,
    this.relax,
    Key? key,
  }) : super(key: key);

  factory RelaxView.dailyBrief({
    required Relax relax,
  }) =>
      RelaxView._(
        type: RelaxViewType.dailyBrief,
        relax: relax,
      );

  factory RelaxView.article() => const RelaxView._(type: RelaxViewType.article);

  final RelaxViewType type;
  final Relax? relax;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case RelaxViewType.dailyBrief:
        content = _DailyBriefContent(relax: relax!);
        break;
      case RelaxViewType.article:
        content = const _ArticleContent();
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimens.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.m),
        color: () {
          switch (type) {
            case RelaxViewType.dailyBrief:
              return AppColors.lightGrey;
            case RelaxViewType.article:
              return AppColors.lightGrey;
          }
        }(),
      ),
      child: content,
    );
  }
}

extension on BuildContext {
  void goToExplore() {
    navigateTo(
      const TabBarPageRoute(
        children: [
          ExploreTabGroupRouter(
            children: [
              ExplorePageRoute(),
            ],
          )
        ],
      ),
    );
  }
}
