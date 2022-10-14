import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/call_to_action.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/relax.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

enum RelaxViewType { dailyBrief, article }

const _iconSize = 54.0;
const _dailyBriefCardHeight = 280.0;
const _articleCardHeight = 350.0;

class RelaxView extends StatelessWidget {
  const RelaxView._({
    required this.height,
    required this.type,
    this.relax,
    this.briefId,
    Key? key,
  }) : super(key: key);

  factory RelaxView.dailyBrief({
    required Relax relax,
  }) =>
      RelaxView._(
        type: RelaxViewType.dailyBrief,
        height: _dailyBriefCardHeight,
        relax: relax,
      );

  factory RelaxView.article(
    String? briefId,
  ) =>
      RelaxView._(
        type: RelaxViewType.article,
        height: _articleCardHeight,
        briefId: briefId,
      );

  final double height;
  final RelaxViewType type;
  final Relax? relax;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (type) {
      case RelaxViewType.dailyBrief:
        content = _DailyBriefContent(relax: relax!);
        break;
      case RelaxViewType.article:
        content = _ArticleContent(briefId: briefId);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.m),
        color: () {
          switch (type) {
            case RelaxViewType.dailyBrief:
              return AppColors.darkLinen;
            case RelaxViewType.article:
              return AppColors.linen;
          }
        }(),
      ),
      height: height,
      width: double.infinity,
      child: content,
    );
  }
}

class _DailyBriefContent extends StatelessWidget {
  const _DailyBriefContent({
    required this.relax,
    Key? key,
  }) : super(key: key);

  final Relax relax;

  @override
  Widget build(BuildContext context) {
    final callToAction = relax.callToAction;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        _DailyBriefHeadline(relax),
        const SizedBox(height: AppDimens.s),
        Text(
          relax.message,
          style: AppTypography.b2Medium,
          textAlign: TextAlign.center,
        ),
        if (callToAction != null) ...[
          const SizedBox(height: AppDimens.xxxl),
          _DailyBriefFooter(callToAction),
        ] else
          const SizedBox.shrink(),
        const Spacer(),
      ],
    );
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({
    required this.briefId,
    Key? key,
  }) : super(key: key);

  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        const _ArticleHeadline(),
        const Spacer(flex: 1),
        _ArticleFooter(briefId),
        const SizedBox(height: AppDimens.xl),
      ],
    );
  }
}

class _DailyBriefHeadline extends HookWidget {
  const _DailyBriefHeadline(this.relax, {Key? key}) : super(key: key);

  final Relax relax;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (relax.icon != null) ...[
            const SizedBox(height: AppDimens.l),
            SvgPicture.string(
              relax.icon!,
              width: _iconSize,
              height: _iconSize,
            ),
          ],
          InformedMarkdownBody(
            markdown: relax.headline,
            baseTextStyle: AppTypography.h2Medium,
            highlightColor: AppColors.limeGreen,
            textAlignment: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DailyBriefFooter extends StatelessWidget {
  const _DailyBriefFooter(this.callToAction, {Key? key}) : super(key: key);

  final CallToAction callToAction;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          if (callToAction.preText != null) ...[
            TextSpan(
              text: callToAction.preText,
              style: AppTypography.b2Medium,
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: callToAction.actionText,
            style: AppTypography.b2Bold.copyWith(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = context.goToExplore,
          ),
        ],
      ),
    );
  }
}

class _ArticleHeadline extends StatelessWidget {
  const _ArticleHeadline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectorGraphics.bigSearch),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: "_${LocaleKeys.article_relatedContent_cantGetEnough.tr()}_",
            baseTextStyle: AppTypography.h2Medium,
            highlightColor: AppColors.limeGreen,
            textAlignment: TextAlign.center,
          ),
          Text(
            LocaleKeys.article_relatedContent_thereAreManyMore.tr(),
            style: AppTypography.h2Medium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArticleFooter extends StatelessWidget {
  const _ArticleFooter(
    this.briefId, {
    Key? key,
  }) : super(key: key);

  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.goToExplore,
      child: Text(
        (briefId != null ? LocaleKeys.article_relatedContent_goToExplore : LocaleKeys.article_goBackToExplore).tr(),
        style: AppTypography.b2Bold.copyWith(decoration: TextDecoration.underline),
        textAlign: TextAlign.center,
      ),
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
