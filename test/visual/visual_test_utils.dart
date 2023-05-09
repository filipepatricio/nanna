import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/informed_app.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../flutter_test_config.dart';

typedef DependencyOverrideCallback = Future<void> Function(GetIt getIt);

const defaultDevices = [
  Device(name: 'iPhone_08,4', size: Size(320, 568)), // iPhone SE
  Device(name: 'iPhone_09,3', size: Size(375, 667)), // iPhone 7
  Device(name: 'iPhone_10,6', size: Size(375, 812)), // iPhone X
  Device(name: 'iPhone_13,4', size: Size(428, 926)), // iPhone 12 Pro Max
];

const shareImage = Device(name: 'share_image', size: Size(720, 1280));
const shareSticker = Device(name: 'share_sticker', size: Size(480, 640));

/// Can be used to take screenshots of very long lists without hiding overflowing widgets.
const highDevice = Device(name: 'high_screen', size: Size(375, 1500));
const veryHighDevice = Device(name: 'very_high_screen', size: Size(375, 2400));
const ultraHighDevice = Device(name: 'ultra_high_screen', size: Size(375, 5000));

/// Test matrix to define which flavors and which devices should be used for a visual test.
class TestConfig {
  const TestConfig._({
    this.flavor = AppConfig.mock,
    this.devices = defaultDevices,
    this.autoHeight = false,
  });

  factory TestConfig.stickerDevice() => const TestConfig._(
        flavor: AppConfig.mock,
        devices: [shareImage],
      );

  factory TestConfig.withDevices(List<Device> devices) => TestConfig._(devices: devices);

  factory TestConfig.autoHeight() => const TestConfig._(autoHeight: true, devices: defaultDevices);

  static const unitTesting = TestConfig._();

  final AppConfig flavor;
  final List<Device> devices;
  final bool autoHeight;
}

late List<Device> _selectedDevices;
late String _nameOfCurrentVisualTest;
late String _defaultGoldenFileName;
late bool _autoHeight;
bool _matchGoldenFileCalled = false;
bool _defaultGoldenFileNameUsed = false;
AdaptiveThemeMode themeMode = AdaptiveThemeMode.dark;

void visualTest(
  Object widgetTypeOrDescription,
  VisualTestCallback callback, {
  TestConfig testConfig = TestConfig.unitTesting,
  bool? skip,
}) {
  testGoldens(
    '$widgetTypeOrDescription (${testConfig.flavor.name})',
    (tester) async {
      _autoHeight = testConfig.autoHeight;
      _selectedDevices = testConfig.devices.toList();
      _nameOfCurrentVisualTest = widgetTypeOrDescription.toString();
      kIsAppleDevice = true;
      _defaultGoldenFileName = _nameOfCurrentVisualTest
          .replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (match) => '_${match.group(0)}')
          .replaceAll(' ', '_')
          .toLowerCase();
      _matchGoldenFileCalled = false;
      _defaultGoldenFileNameUsed = false;
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
        await callback(tester);
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
    },
    tags: 'visual',
    skip: skip,
  );
}

extension StartAppExtension on WidgetTester {
  Future<MainRouter> startApp<T extends Object>({
    PageRouteInfo initialRoute = defaultInitialRoute,
    DependencyOverrideCallback? dependencyOverride,
  }) async {
    final isTab = isTabRoute(initialRoute);
    final mainRouter = MainRouter(GlobalKey());

    final getIt = await configureDependencies(AppConfig.mock.name);
    getIt.allowReassignment = true;
    await dependencyOverride?.call(getIt);

    await pumpWidgetBuilder(
      InformedApp(
        mainRouter: mainRouter,
        getIt: getIt,
        themeMode: themeMode,
      ),
      // pumpWidgetBuilder by default adds it's own MaterialApp over child we pass, this code disables it
      wrapper: (widget) => widget,
    );

    await pumpAndSettle();

    if (initialRoute != defaultInitialRoute) {
      if (isTab) {
        await mainRouter.navigate(TabBarPageRoute(children: [initialRoute]));
      } else {
        await mainRouter.navigate(initialRoute);
      }
    }

    await loadImages();

    return mainRouter;
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
    final fileName = '$fileNamePrefix.${themeMode.name}';

    await multiScreenGolden(
      this,
      fileName,
      devices: _selectedDevices,
      autoHeight: _autoHeight,
    );
  }

  void mockDependency<T extends Object>(T dependency) {
    final BuildContext context = element(find.byType(Container));
    context.read<GetIt>().registerSingleton<T>(dependency);
  }
}

typedef VisualTestCallback = Future<void> Function(WidgetTester widgetTester);

PageRouteInfo<dynamic> placeholderRouteWrapper({
  required List<Widget> children,
  EdgeInsets? padding,
}) {
  return PlaceholderPageRoute(
    child: Material(
      child: SnackbarParentView(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDimens.m),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...children.expand(
                  (item) => [item, const SizedBox(height: AppDimens.m)],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
