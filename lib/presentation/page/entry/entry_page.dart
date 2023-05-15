import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
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
      state.whenOrNull(
        signedIn: context.replaceToMain,
        notSignedIn: context.resetToOnboarding,
        subscribed: context.resetToSignIn,
        guest: context.replaceToMain,
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
          child: ErrorView(
            retryCallback: cubit.initialize,
          ),
        ),
        orElse: () => const LoaderLogo(),
      ),
    );
  }
}
