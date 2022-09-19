part of '../subscription_page.dart';

class _SubscriptionPlansLoadingView extends StatelessWidget {
  const _SubscriptionPlansLoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        SizedBox(
          height: 50,
          child: LoadingShimmer(
            mainColor: AppColors.darkLinen,
            radius: AppDimens.m,
          ),
        ),
        SizedBox(height: AppDimens.l),
        SizedBox(
          height: 250,
          child: LoadingShimmer(
            mainColor: AppColors.darkLinen,
            radius: AppDimens.ml,
          ),
        ),
        SizedBox(height: AppDimens.m),
        SizedBox(
          height: 100,
          child: LoadingShimmer(
            mainColor: AppColors.darkLinen,
            radius: AppDimens.ml,
          ),
        ),
        SizedBox(height: AppDimens.xl),
        SizedBox(
          height: 50,
          child: LoadingShimmer(
            mainColor: AppColors.darkLinen,
            radius: AppDimens.m,
          ),
        ),
      ],
    );
  }
}
