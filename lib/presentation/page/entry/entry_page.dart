import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EntryPage extends HookWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<EntryPageCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<EntryPageCubit, EntryPageState>(cubit, (cubit, state, context) {
      state.maybeWhen(
        alreadySignedIn: () => AutoRouter.of(context).pushAndPopUntil(
          const MainPageRoute(),
          predicate: (_) => false,
        ),
        notSignedIn: () => AutoRouter.of(context).pushAndPopUntil(
          const SignInPageRoute(),
          predicate: (_) => false,
        ),
        onboarding: () => AutoRouter.of(context).pushAndPopUntil(
          const OnboardingPageRoute(),
          predicate: (_) => false,
        ),
        orElse: () {},
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return Scaffold(
      body: state.maybeMap(
        error: (_) => Center(
          child: GeneralErrorView(
            title: LocaleKeys.common_error_title.tr(),
            content: LocaleKeys.common_error_body.tr(),
            action: LocaleKeys.common_tryAgain.tr(),
            retryCallback: () => cubit.initialize(),
          ),
        ),
        orElse: () => const LoaderLogo(),
      ),
    );
  }
}
