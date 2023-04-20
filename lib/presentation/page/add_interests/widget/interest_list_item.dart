part of '../add_interests_page.dart';

class _InterestListItem extends StatelessWidget {
  const _InterestListItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14.5, horizontal: AppDimens.m),
        decoration: BoxDecoration(
          color: isSelected ? category.color : AppColors.of(context).blackWhiteSecondary,
          borderRadius: BorderRadius.circular(AppDimens.modalRadius),
          border: Border.all(
            color: isSelected
                ? (category.color ?? AppColors.of(context).blackWhiteSecondary)
                : AppColors.of(context).buttonSecondaryFrame,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              category.name,
              style: AppTypography.sansTitleSmallLausanne.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.check,
                color: AppColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
