import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class OwnersNoteContainer extends StatelessWidget {
  const OwnersNoteContainer({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: AppDimens.sl),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.brandAccent)),
      ),
      child: child,
    );
  }
}

class OwnersNote extends StatelessWidget {
  const OwnersNote({
    required this.note,
    this.curationInfo,
    this.showRecommendedBy,
    Key? key,
  }) : super(key: key);

  final String note;
  final CurationInfo? curationInfo;
  final bool? showRecommendedBy;

  @override
  Widget build(BuildContext context) {
    final curationInfo = this.curationInfo;
    final showRecommendedBy = this.showRecommendedBy;
    return OwnersNoteContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InformedMarkdownBody(
            markdown: note,
            baseTextStyle: AppTypography.sansTextSmallLausanne.copyWith(
              color: AppColors.of(context).textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.xs),
          if (curationInfo != null && showRecommendedBy != null && showRecommendedBy) ...[
            CurationInfoView(
              curationInfo: curationInfo,
              imageDimension: AppDimens.smallAvatarSize,
              style: AppTypography.sansTextNanoLausanne.copyWith(
                color: AppColors.of(context).textTertiary,
                height: 1,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
