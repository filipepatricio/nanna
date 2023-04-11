import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/error_view.dart';
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

    return AnnotatedRegion(
      value: AdaptiveTheme.of(context).brightness == Brightness.dark
          ? InformedTheme.systemUIOverlayStyleDark
          : InformedTheme.systemUIOverlayStyleLight,
      child: Scaffold(
        body: state.maybeMap(
          error: (_) => Center(
            child: ErrorView(
              retryCallback: () => cubit.initialize(),
            ),
          ),
          orElse: () => const LoaderLogo(),
        ),
      ),
    );
  }
}
