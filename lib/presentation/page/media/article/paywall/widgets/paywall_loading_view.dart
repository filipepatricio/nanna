part of '../article_paywall_view.dart';

class _PaywallLoadingView extends StatelessWidget {
  const _PaywallLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(
          height: 50,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
        SizedBox(height: AppDimens.l),
        SizedBox(
          height: 200,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.ml,
          ),
        ),
        SizedBox(height: AppDimens.l),
        SizedBox(
          height: 50,
          child: LoadingShimmer.defaultColor(
            radius: AppDimens.m,
          ),
        ),
      ],
    );
  }
}
