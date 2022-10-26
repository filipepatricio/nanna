import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/restart_app_widget.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_popup.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends HookWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();

    useCubitListener<MainCubit, MainState>(cubit, (cubit, state, context) {
      state.maybeMap(
        tokenExpired: (_) => _onTokenExpiredEvent(context),
        navigate: (navigate) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async => await _closeWebView().then(
              (_) {
                _resetNestedRouters();
                _navigateToPath(context, navigate.path);
              },
            ),
          );
        },
        multiNavigate: (navigate) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async => await _closeWebView().then(
              (_) {
                _resetNestedRouters();
                for (final path in navigate.path) {
                  _navigateToPath(context, path);
                }
              },
            ),
          );
        },
        showReleaseNote: (state) => ReleaseNotePopup.show(
          context: context,
          releaseNote: state.releaseNote,
        ),
        resetRouteStack: (_) => RestartAppWidget.restartApp(context),
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
    _navigatorKey.currentContext?.router.popUntilRoot();
  }

  Future<void> _closeWebView() async {
    if (!kIsTest) await closeInAppWebView();
  }

  void _navigateToPath(BuildContext context, String path) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await context.navigateNamedTo(
        path,
        onFailure: (failure) => Fimber.e('Navigation to path - $path - failed', ex: failure),
      ),
    );
  }
}
