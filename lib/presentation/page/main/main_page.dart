import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/informed_theme.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/release_notes/release_note_popup.dart';
import 'package:better_informed_mobile/presentation/widget/restart_app_widget.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends HookWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainCubit>();
    final previousAppState = useValueNotifier<AppLifecycleState?>(null);

    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed) previousAppState.value = previous;

      switch (current) {
        case AppLifecycleState.resumed:
        case AppLifecycleState.inactive:
          cubit.appMovedToForeground();
          break;
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          cubit.appMovedToBackground();
          break;
      }
    });

    useCubitListener<MainCubit, MainState>(cubit, (cubit, state, context) {
      state.maybeMap(
        tokenExpired: (_) => _onTokenExpiredEvent(context),
        navigate: (navigate) async {
          if (previousAppState.value == null) {
            await Future.delayed(const Duration(milliseconds: 250));
            if (context.mounted) {
              await _navigateToPath(context, navigate.path);
            }
            return;
          }

          await _closeWebView();
          _resetNestedRouters();

          await Future.delayed(const Duration(milliseconds: 250));
          if (context.mounted) {
            await _navigateToPath(context, navigate.path);
          }
        },
        multiNavigate: (navigate) async {
          if (previousAppState.value == null) {
            await Future.delayed(const Duration(milliseconds: 250));
            for (final path in navigate.path) {
              if (context.mounted) {
                await _navigateToPath(context, path);
              }
            }
            return;
          }

          await _closeWebView();
          _resetNestedRouters();

          await Future.delayed(const Duration(milliseconds: 250));
          for (final path in navigate.path) {
            if (context.mounted) {
              await _navigateToPath(context, path);
            }
          }
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

    return AnnotatedRegion(
      value: AdaptiveTheme.of(context).brightness == Brightness.dark
          ? InformedTheme.systemUIOverlayStyleDark
          : InformedTheme.systemUIOverlayStyleLight,
      child: AutoRouter(
        navigatorKey: _navigatorKey,
      ),
    );
  }

  void _onTokenExpiredEvent(BuildContext context) {
    context.router.replaceAll([const EntryPageRoute()]);
  }

  void _resetNestedRouters() {
    _navigatorKey.currentContext?.router.popUntilRoot();
  }

  Future<void> _closeWebView() async {
    if (!kIsTest) await closeInAppWebView();
  }

  Future<void> _navigateToPath(BuildContext context, String path) async {
    await context.navigateNamedTo(
      path,
      onFailure: (failure) => Fimber.e('Navigation to path - $path - failed', ex: failure),
    );
  }
}
