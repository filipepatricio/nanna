import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/better_informed_app.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/src/keyboard_visibility_handler.dart';
import 'package:flutter_test/flutter_test.dart';

const defaultDevices = [
  // Device('iPhone_11Pro', Size(375, 812), devicePixelRatio: 3, safeArea: EdgeInsets.only(top: 20)),
  // TODO: Cleanup this list and leave a smaller screen and Android device when multiple devices testing works
  // Device('Samsung_S20', Size(360, 800), devicePixelRatio: 4, safeArea: EdgeInsets.only(top: 24)),
  Device('iPhone_SE', Size(320, 568), devicePixelRatio: 2, safeArea: EdgeInsets.only(top: 20)),
  // Device('Samsung_S7', Size(360, 640), devicePixelRatio: 3, safeArea: EdgeInsets.only(top: 24)),
];

/// Can be used to take screenshots of very long lists without hiding overflowing widgets.
const veryHighDevice =
    Device('very_high_device_1700px', Size(360, 1700), devicePixelRatio: 1, safeArea: EdgeInsets.zero);

/// Test matrix to define which flavors and which devices should be used for a visual test.
class TestConfig {
  TestConfig._({required this.flavor, Iterable<Device> devices = defaultDevices})
      : assert(flavor.name == AppConfig.mock().name),
        devices = devices.toSet();

  static final TestConfig unitTesting = TestConfig._(flavor: AppConfig.mock());

  TestConfig withDevices(Iterable<Device> devices) => TestConfig._(flavor: flavor, devices: devices);

  final AppConfig flavor;
  final Set<Device> devices;
}

late Device _device;
bool _matchGoldenFileCalled = false;
late String _nameOfCurrentVisualTest;
late String _defaultGoldenFileName;
bool _defaultGoldenFileNameUsed = false;

void visualTest(Object widgetTypeOrDescription, TestConfig testConfig, VisualTestCallback callback, {bool? skip}) {
  for (final device in testConfig.devices) {
    testWidgets('$widgetTypeOrDescription (${testConfig.flavor.name}, $device)', (tester) async {
      _device = device;
      _nameOfCurrentVisualTest = widgetTypeOrDescription.toString();
      _defaultGoldenFileName = _nameOfCurrentVisualTest
          .replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (match) => '_${match.group(0)}')
          .replaceAll(' ', '_')
          .toLowerCase();
      _matchGoldenFileCalled = false;
      _defaultGoldenFileNameUsed = false;
      kIsAppleDevice = _device.name.startsWith('iPhone');
      await tester.binding.setSurfaceSize(_device.screenSize);
      tester.binding.window
        ..devicePixelRatioTestValue = _device.devicePixelRatio
        ..physicalSizeTestValue = _device.screenSize * _device.devicePixelRatio
        ..paddingTestValue = _SafeAreaPadding(_device.safeArea)
        ..localesTestValue = [availableLocales.entries.first.value];
      final onError = FlutterError.onError;
      FlutterError? overflowError;
      FlutterError.onError = (details) {
        final exception = details.exception;
        if (exception is FlutterError && exception.toString().startsWith('A RenderFlex overflowed')) {
          // We ignore the overflow error here (so that screenshots are recorded) and throw it later ...
          overflowError = exception;
        } else {
          onError?.call(details);
        }
      };
      try {
        await callback(tester, _device);
        if (!_matchGoldenFileCalled) {
          throw AssertionError('matchGoldenFile(...) was not called by the visual test');
        }
      } finally {
        FlutterError.onError = onError;
        await tester.binding.setSurfaceSize(null);
        tester.binding.window.clearAllTestValues();
      }
      if (overflowError != null) {
        throw overflowError!;
      }
    }, tags: 'visual', skip: skip);
  }
}

Future<void> matchGoldenFile([String? fileNamePrefix]) async {
  if (fileNamePrefix == null) {
    if (_defaultGoldenFileNameUsed) {
      throw AssertionError(
        'You need to call matchGoldenFile with an argument if you call it multiple times in a single visual test',
      );
    }
    _defaultGoldenFileNameUsed = true;
    // ignore: parameter_assignments
    fileNamePrefix = _defaultGoldenFileName;
  }
  _matchGoldenFileCalled = true;
  final fileName = '$fileNamePrefix.${_device.name}.png';
  await expectLater(find.byType(BetterInformedApp), matchesGoldenFile('goldens/$fileName'));
}

const _currentUserNotSpecified = Object();

const _defaultInitialRoute = MainPageRoute();

extension StartAppExtension on WidgetTester {
  Future<void> startApp({
    PageRouteInfo initialRoute = _defaultInitialRoute,
    Object currentUser = _currentUserNotSpecified,
    List<Cubit> providerOverrides = const [],
  }) async {
    // by default the keyboard should not be visible
    KeyboardVisibilityHandler.setVisibilityForTesting(false);

    final isTab = isTabRoute(initialRoute);
    final mainRouter = MainRouter(mainRouterKey);
    final informedApp = BetterInformedApp(mainRouter: mainRouter);

    await pumpWidget(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: availableLocales.values.toList(),
        startLocale: availableLocales.values.first,
        fallbackLocale: availableLocales[fallbackLanguageCode],
        useOnlyLangCode: true,
        saveLocale: true,
        child: informedApp,
      ),
    );

    if (initialRoute != _defaultInitialRoute) {
      if (isTab) {
        await mainRouter.navigate(MainPageRoute(children: [initialRoute]));
      } else {
        await mainRouter.navigate(initialRoute);
      }
    }

    await pumpAndSettle();

    await loadImages();
  }

  Future<void> loadImages() async {
    // See https://github.com/flutter/flutter/issues/38997#issuecomment-524992589
    // and https://github.com/eBay/flutter_glove_box/blob/master/packages/golden_toolkit/lib/src/testing_tools.dart ...
    final imageElements = find.byType(Image, skipOffstage: false).evaluate();
    final containerElements = find.byType(DecoratedBox, skipOffstage: false).evaluate();
    await runAsync(() async {
      for (final imageElement in imageElements) {
        final widget = imageElement.widget;
        if (widget is Image) {
          await precacheImage(widget.image, imageElement);
        }
      }
      for (final container in containerElements) {
        final widget = container.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          if (decoration.image != null) {
            await precacheImage(decoration.image!.image, container);
          }
        }
      }
    });
    await pumpAndSettle();
  }
}

bool isTabRoute(PageRouteInfo route) {
  final routeName = route.routeName;
  return dashboardTabRouter.children?.map((tabRoute) => tabRoute.name).contains(routeName) ?? false;
}

typedef VisualTestCallback = Future<void> Function(WidgetTester widgetTester, Device device);

class Device {
  const Device(this.name, this.screenSize, {this.devicePixelRatio = 1, this.safeArea = EdgeInsets.zero});

  final String name;
  final Size screenSize;
  final double devicePixelRatio;
  final EdgeInsets safeArea;

  @override
  String toString() {
    return name;
  }
}

class _SafeAreaPadding implements WindowPadding {
  _SafeAreaPadding(EdgeInsets safeArea)
      : top = safeArea.top,
        right = safeArea.right,
        bottom = safeArea.bottom,
        left = safeArea.left;

  @override
  final double top;

  @override
  final double right;

  @override
  final double bottom;

  @override
  final double left;
}
