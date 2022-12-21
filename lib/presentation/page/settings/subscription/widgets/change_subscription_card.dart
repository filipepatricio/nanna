part of '../settings_subscription_page.dart';

class _ChangeSubscriptionCard extends StatelessWidget {
  const _ChangeSubscriptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.m),
        decoration: BoxDecoration(
          color: AppColors.of(context).blackWhiteSecondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.m),
          ),
          border: Border.all(color: AppColors.of(context).borderPrimary),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.s),
              ),
              child: SvgPicture.asset(
                icon,
                height: AppDimens.xxxl,
              ),
            ),
            const SizedBox(width: AppDimens.m),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h4Medium.copyWith(height: 1.5),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: AppTypography.subH1Regular.copyWith(height: 1.5),
                  ),
              ],
            ),
            const Spacer(),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppDimens.m,
              ),
          ],
        ),
      ),
    );
  }
}
