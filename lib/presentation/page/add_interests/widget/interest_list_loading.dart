part of '../add_interests_page.dart';

class _InterestListLoading extends StatelessWidget {
  const _InterestListLoading();

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer.defaultColor(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final _ in List.generate(10, (index) => index)) ...[
            const _InterestListLoadingItem(),
            const SizedBox(height: AppDimens.s),
          ],
        ],
      ),
    );
  }
}

class _InterestListLoadingItem extends StatelessWidget {
  const _InterestListLoadingItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.5, horizontal: AppDimens.m),
      decoration: BoxDecoration(
        color: AppColors.of(context).blackWhiteSecondary,
        borderRadius: BorderRadius.circular(AppDimens.modalRadius),
      ),
      child: Row(
        children: [
          Opacity(
            opacity: 0,
            child: Text(
              '-',
              style: AppTypography.sansTitleSmallLausanne.w550,
            ),
          ),
          const Spacer(),
          const Opacity(
            opacity: 0,
            child: Icon(
              Icons.check,
            ),
          ),
        ],
      ),
    );
  }
}
