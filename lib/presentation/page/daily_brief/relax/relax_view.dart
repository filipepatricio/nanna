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

class RelaxView extends StatelessWidget {
  const RelaxView._({
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
        relax: relax,
      );

  factory RelaxView.article(
    String? briefId,
  ) =>
      RelaxView._(
        type: RelaxViewType.article,
        briefId: briefId,
      );

  final RelaxViewType type;
  final Relax? relax;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: AppDimens.briefEntryCardStackHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          _Content(
            relax: relax,
            type: type,
          ),
          _Message(
            message: relax?.message,
            type: type,
          ),
          _Footer(
            type: type,
            briefId: briefId,
            callToAction: relax?.callToAction,
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.type,
    required this.callToAction,
    required this.briefId,
    Key? key,
  }) : super(key: key);

  final RelaxViewType type;
  final CallToAction? callToAction;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case RelaxViewType.dailyBrief:
        if (callToAction != null) {
          return _DailyBriefFooter(callToAction!);
        } else {
          return const SizedBox.shrink();
        }
      case RelaxViewType.article:
        return _ArticleFooter(briefId);
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.type,
    required this.message,
    Key? key,
  }) : super(key: key);

  final RelaxViewType type;
  final String? message;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case RelaxViewType.dailyBrief:
        return Expanded(
          child: Center(
            child: Text(
              message!,
              style: AppTypography.b2Medium,
            ),
          ),
        );
      case RelaxViewType.article:
        return const Spacer();
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.relax,
    required this.type,
    Key? key,
  }) : super(key: key);

  final Relax? relax;
  final RelaxViewType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case RelaxViewType.dailyBrief:
        return _DailyBriefContent(relax!);
      case RelaxViewType.article:
        return const _ArticleContent();
    }
  }
}

class _DailyBriefContent extends HookWidget {
  const _DailyBriefContent(this.relax, {Key? key}) : super(key: key);

  final Relax relax;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (relax.icon != null)
            SvgPicture.string(
              relax.icon!,
              width: _iconSize,
              height: _iconSize,
            )
          else
            SvgPicture.asset(AppVectorGraphics.relaxCoffee),
          const SizedBox(height: AppDimens.l),
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

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({Key? key}) : super(key: key);

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
