part of '../daily_brief_page.dart';

class _TodaysBriefDivider extends StatelessWidget {
  const _TodaysBriefDivider.cover() : _height = 8.0;

  const _TodaysBriefDivider.section() : _height = 32.0;

  final double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.lightGrey,
            AppColors.darkLinen,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
