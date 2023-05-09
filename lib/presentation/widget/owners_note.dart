import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/accent_border_container.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OwnersNote extends StatelessWidget {
  const OwnersNote({
    required this.note,
    this.isNoteCollapsible = false,
    this.curationInfo,
    this.showRecommendedBy,
    this.onTap,
    super.key,
  }) : assert(isNoteCollapsible && onTap != null || !isNoteCollapsible, 'Define onTap callback for collapsible note');

  final String note;
  final bool isNoteCollapsible;
  final CurationInfo? curationInfo;
  final bool? showRecommendedBy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final curationInfo = this.curationInfo;
    final showRecommendedBy = this.showRecommendedBy;

    final noteStyle = AppTypography.sansTextSmallLausanne.copyWith(
      color: AppColors.of(context).textSecondary,
    );

    return AccentBorderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isNoteCollapsible)
            _CollapsibleNoteWrapper(
              note: note,
              noteStyle: noteStyle,
              onTap: onTap!,
            )
          else
            InformedMarkdownBody(
              markdown: note,
              baseTextStyle: noteStyle,
            ),
          const SizedBox(height: AppDimens.xs),
          if (curationInfo != null && showRecommendedBy != null && showRecommendedBy) ...[
            CurationInfoView(
              curationInfo: curationInfo,
              imageDimension: AppDimens.smallAvatarSize,
              style: AppTypography.sansTextNanoLausanne.copyWith(
                color: AppColors.of(context).textSecondary,
                height: 1,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _CollapsibleNoteWrapper extends HookWidget {
  const _CollapsibleNoteWrapper({
    required this.note,
    required this.noteStyle,
    required this.onTap,
  });

  final String note;
  final TextStyle noteStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final eventTracker = useEventTrackingController();
    final isCollapsedNotifier = useValueNotifier(true);

    return GeneralEventTracker(
      controller: eventTracker,
      child: ValueListenableBuilder(
        valueListenable: isCollapsedNotifier,
        builder: (context, isCollapsed, _) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final newIsCollapsed = !isCollapsed;

              newIsCollapsed
                  ? eventTracker.track(AnalyticsEvent.articleNoteCollapsed())
                  : eventTracker.track(AnalyticsEvent.articleNoteUncollapsed());

              isCollapsedNotifier.value = newIsCollapsed;
            },
            child: SizedBox(
              height: isCollapsed ? noteStyle.lineHeight * 2 : null,
              child: ClipRRect(
                child: Stack(
                  children: [
                    // Used to clip child and prevent overflow on collapsing
                    Wrap(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformedMarkdownBody(
                              markdown: note,
                              baseTextStyle: noteStyle,
                            ),
                            if (!isCollapsed) ...[
                              const SizedBox(height: AppDimens.m),
                              GestureDetector(
                                onTap: onTap,
                                child: Text(
                                  context.l10n.article_note_readFullArticle,
                                  style: AppTypography.sansTextSmallLausanneBold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: const [0, 0.25],
                            colors: [
                              AppColors.of(context).backgroundPrimary.withOpacity(0),
                              AppColors.of(context).backgroundPrimary,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: AppDimens.xxxl,
                        ),
                        child: Text(
                          isCollapsed ? context.l10n.article_note_showMore : context.l10n.article_note_showLess,
                          style: isCollapsed
                              ? AppTypography.sansTextSmallLausanneBold
                              : AppTypography.sansTextSmallLausanne,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
