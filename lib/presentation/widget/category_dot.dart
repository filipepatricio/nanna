import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';

const _dotSize = 10.0;
const _spacing = 6.0;

class CategoryDot extends StatelessWidget {
  const CategoryDot({
    required this.category,
    this.labelColor,
    super.key,
  });

  final Category category;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: _dotSize,
          width: _dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category.color ?? AppColors.categoriesBackgroundShowMeEverything,
          ),
        ),
        const SizedBox(width: _spacing),
        Text(
          category.name,
          style: AppTypography.sansTextNanoLausanne.copyWith(
            color: labelColor ?? AppColors.of(context).textTertiary,
          ),
          textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
        ),
      ],
    );
  }
}
