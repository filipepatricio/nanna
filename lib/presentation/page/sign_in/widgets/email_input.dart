part of '../sign_in_page.dart';

@visibleForTesting
class EmailInput extends StatelessWidget {
  const EmailInput({
    required this.controller,
    required this.cubit,
    required this.validEmail,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final SignInPageCubit cubit;
  final bool validEmail;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      key: _emailInputKey,
      controller: controller,
      onChanged: cubit.updateEmail,
      style: AppTypography.b2Regular.copyWith(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGrey,
        hintText: LocaleKeys.signIn_emailLabel.tr(),
        hintStyle: AppTypography.b2Regular.copyWith(color: AppColors.textGrey),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.textPrimary),
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDimens.m, vertical: AppDimens.m),
      ),
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.none,
      onSubmitted: validEmail ? (value) => cubit.sendMagicLink() : null,
    );
  }
}
