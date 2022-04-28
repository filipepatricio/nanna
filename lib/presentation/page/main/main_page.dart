import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

final mainPageKey = GlobalKey();

class MainPage extends HookWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();

    useCubitListener<MainCubit, MainState>(cubit, (cubit, state, context) {
      state.maybeMap(
        tokenExpired: (_) => _onTokenExpiredEvent(context),
        navigate: (navigate) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
            await closeWebView();
            _resetNestedRouters();
            await context.navigateNamedTo(
              navigate.path,
              onFailure: (failure) {
                Fimber.e('Incoming push - navigation failed', ex: failure);
              },
            );
          });
        },
        multiNavigate: (navigate) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
            await closeWebView();
            _resetNestedRouters();
            for (final path in navigate.path) {
              await context.navigateNamedTo(
                path,
                onFailure: (failure) {
                  Fimber.e('Incoming push - navigation failed', ex: failure);
                },
              );
            }
          });
        },
        orElse: () {},
      );
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return AutoRouter(
      navigatorKey: _navigatorKey,
    );
  }

  void _onTokenExpiredEvent(BuildContext context) {
    AutoRouter.of(context).replaceAll([const SignInPageRoute()]);
  }

  void _resetNestedRouters() {
    final nestedNavigatorContext = _navigatorKey.currentContext;
    if (nestedNavigatorContext != null) {
      AutoRouter.of(nestedNavigatorContext).popUntilRoot();
    }
  }
}
