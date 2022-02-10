import 'dart:async';

import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/src/keyboard_visibility_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

late BetterInformedTestWidgetsFlutterBinding binding;
final debugPrintBuffer = <String>[];

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetController.hitTestWarningShouldBeFatal = true;

  await configureDependencies(AppConfig.mock.name);
  // Prevent printing to stdout (unless a test fails) ...
  binding = BetterInformedTestWidgetsFlutterBinding();
  setUp(() async {
    debugPrintBuffer.clear();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
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
