part of '../relax_view.dart';

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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DailyBriefHeadline(relax),
        const SizedBox(height: AppDimens.sl),
        Text(
          relax.message,
          style: AppTypography.b2Regular.copyWith(
            color: AppColors.darkerGrey,
          ),
          textAlign: TextAlign.center,
        ),
        if (callToAction != null) ...[
          const SizedBox(height: AppDimens.xl),
          _DailyBriefFooter(callToAction),
        ]
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
              style: AppTypography.b2Regular.copyWith(
                color: AppColors.darkerGrey,
              ),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(
            text: callToAction.actionText,
            style: AppTypography.b2Bold.copyWith(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = context.goToExplore,
          ),
        ],
      ),
    );
  }
}
