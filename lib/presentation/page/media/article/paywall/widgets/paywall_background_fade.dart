part of '../article_paywall_view.dart';

const _backgroundFadeHeight = 200.0;

class _PaywallBackgroundFade extends StatelessWidget {
  const _PaywallBackgroundFade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: Column(
        children: [
          Container(
            height: _backgroundFadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withOpacity(0.0),
                  AppColors.background,
                ],
                stops: const [
                  0.0,
                  1,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
