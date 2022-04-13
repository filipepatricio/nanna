import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/src/keyboard_visibility_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

late BetterInformedTestWidgetsFlutterBinding binding;
final debugPrintBuffer = <String>[];

const defaultInitialRoute = TabBarPageRoute();

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  /// Replaces the need for [EasyLocalization] wrapper widget - part 1
  final content = await File('assets/translations/en.json').readAsString();
  final data = jsonDecode(content) as Map<String, dynamic>;

  WidgetController.hitTestWarningShouldBeFatal = true;

  // Prevent printing to stdout (unless a test fails) ...
  binding = BetterInformedTestWidgetsFlutterBinding();
  setUp(() async {
    debugPrintBuffer.clear();
    SharedPreferences.setMockInitialValues({});
  });

  /// Replaces the need for [EasyLocalization] wrapper widget - part 2
  Localization.load(
    const Locale('en'),
    translations: Translations(data),
  );

  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  KeyboardVisibilityHandler.setVisibilityForTesting(false);
  await loadAppFonts();
  return testMain();
}

class BetterInformedTestWidgetsFlutterBinding extends AutomatedTestWidgetsFlutterBinding {
  BetterInformedTestWidgetsFlutterBinding() {
    showAppDumpInErrors = true;
  }

  // Return `false` here, if you want to have goldens with correct shadows.
  //
  // Unfortunately we can't do this for our automated visual tests,
  // because they become flaky with disableShadows => false.
  @override
  bool get disableShadows => true;

  @override
  void initInstances() {
    super.initInstances();
    FlutterErrorDetails.propertiesTransformers.add(dumpTextWidgetsTransformer);
  }

  @override
  DebugPrintCallback get debugPrintOverride => onlyPrintOnError;
}

Iterable<DiagnosticsNode> dumpTextWidgetsTransformer(Iterable<DiagnosticsNode> properties) sync* {
  for (final property in properties) {
    if (property is DiagnosticsProperty &&
        property.name == 'At the time of the failure, the widget tree looked as follows') {
      String? textDump;
      try {
        // ignore: avoid_dynamic_calls
        (property.value.value as RenderObjectToWidgetElement).visitChildren((child) {
          textDump = dumpText(child);
        });
      } catch (error) {
        // Ignored.
      }
      if (textDump != null) {
        yield DiagnosticsProperty('At the time of the failure, the following text was present', textDump);
      }
    } else {
      yield property;
    }
  }
}

String dumpText(Element root) {
  final sb = StringBuffer();

  void handleNode(DiagnosticsNode node) {
    final value = node.value;
    if (value is RenderObjectElement) {
      final widget = value.widget;
      if (widget is RichText) {
        final text = widget.text;
        // Ignore icons ...
        if (text.style?.fontFamily != 'MaterialIcons') {
          sb.writeln(text.toPlainText());
        }
      }
    }
  }

  void visit(DiagnosticsNode node) {
    handleNode(node);
    node.getChildren().forEach(visit);
  }

  visit(root.toDiagnosticsNode());
  return sb.toString();
}

void onlyPrintOnError(String? message, {int? wrapWidth}) {
  if (StackTrace.current.toString().contains('dumpErrorToConsole')) {
    debugPrintBuffer.forEach(debugPrintSynchronously);
    debugPrintSynchronously(message);
  } else {
    debugPrintBuffer.add(message ?? '');
  }
}

bool isTabRoute(PageRouteInfo route) {
  final routeName = route.routeName;
  return dashboardTabRouter.children?.map((tabRoute) => tabRoute.name).contains(routeName) ?? false;
}
