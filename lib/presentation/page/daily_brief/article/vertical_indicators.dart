import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/cupertino.dart';

class VerticalIndicators extends StatelessWidget {
  final int currentIndex;
  final int pageListLength;

  const VerticalIndicators({required this.currentIndex, required this.pageListLength, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        pageListLength,
        (index) => Expanded(child: _buildDot(currentIndex, index, context)),
      ),
    );
  }

  Widget _buildDot(int currentIndex, int index, BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDimens.s),
        Expanded(
          child: Container(
            width: AppDimens.verticalIndicatorWidth,
            margin: const EdgeInsets.only(right: AppDimens.xs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.ml),
              color:
                  currentIndex == index ? AppColors.darkGreyBackground : AppColors.darkGreyBackground.withOpacity(0.15),
            ),
          ),
        ),
      ],
    );
  }
}
