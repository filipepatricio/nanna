part of '../subscription_page.dart';

class SubscribeButton extends HookWidget {
  const SubscribeButton({
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final SubscriptionPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final state = useCubitBuilder<SubscriptionPageCubit, SubscriptionPageState>(cubit);
    return FilledButton(
      text: LocaleKeys.subscription_tryForFree.tr(),
      onTap: cubit.purchase,
      isLoading: state.maybeWhen(processing: () => true, orElse: () => false),
    );
  }
}
