import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/cupertino.dart';

class Indicators extends StatelessWidget {
  final int currentIndex;
  final int pageListLength;

  const Indicators({required this.currentIndex, required this.pageListLength, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: List.generate(
          pageListLength,
          (index) => _buildDot(currentIndex, index, context),
        ),
      ),
    );
  }

  Widget _buildDot(int currentIndex, int index, BuildContext context) {
    return Container(
      height: AppDimens.indicatorSize,
      width: currentIndex == index ? AppDimens.indicatorSelectedSize : AppDimens.indicatorSize,
      margin: const EdgeInsets.only(right: AppDimens.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.ml),
        color: currentIndex == index ? AppColors.limeGreen : AppColors.limeGreenBleached,
      ),
    );
  }
}
