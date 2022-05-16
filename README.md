# Nanna

Nanna is our Flutter-based mobile app named after [Nanna](<https://en.wikipedia.org/wiki/Nanna_(Norse_deity)>) from Norse mythology. She is associated with joy, peace and the moon, and the name Nanna probably derives from "Mother". Thus, this is a fitting name for our mother of apps.

## Getting Started

Follow those steps to start:

- Check Flutter version in "Mobile introduction" section below
- Run `make get` or `flutter pub get` to get dependencies.
- Run `make build_runner` or `flutter pub run build_runner build --delete-conflicting-outputs` to generate code (routing, json serializers etc.). For FVM users, run `make br`
- Run `make easy_localization` or `flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart` to generate translation files. For FVM users, run `make l10n`

...and you are ready to go.

# Pre-commit hook - how to install

Just run these commands

```
chmod +x scripts/pre-commit.sh
ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
```

This hook will run before commiting anything, and it:

1. Generate all needed files with `build_runner`
2. Update l10n files
3. Run `flutter format` and `flutter analyze` to check for any inconsistencies in sintax

If this last step fails, an error message will be shown and the commit will not be completed

## Running App

Right now we have 3 app flavors: dev, stage and prod. This adds requirement for additional arguments when running flutter app:

`flutter run --release --dart-define=env=dev --flavor dev`

If you want to set custom api host, that application connects to, just include additional argument in run command:

`--dart-define=host=http://127.0.0.1:4000/graphql`

## Project Setup Troubleshoot

- [ ] Problem Sign in with Google:

* Add the `key_<env>.properties` files on the `/android` folder
* Add the `informed.keystore` to an external folder and edit `key_<env>.properties` files `storeFile=` property to have the path of the `informed.keystore`

- [ ] Bug Sign in with Apple on iOS simulator:

* [https://developer.apple.com/forums/thread/651533](https://developer.apple.com/forums/thread/651533?page=3)

- [ ] Sign in with provider - SocketException: OS Error: Connection refused, errno = 111

* Start app with:

`—dart-define=host=http://<your machine ip on the network>:4000/graphql`

- [https://fluttercorner.com/socketexception-os-error-connection-refused-errno-111-in-flutter/](https://fluttercorner.com/socketexception-os-error-connection-refused-errno-111-in-flutter/)

or with:

`—dart-define=host=http://localhost:4000/graphql`

and run on terminal:

`adb reverse tcp:4000 tcp:4000`

- [https://stackoverflow.com/a/60655655/3100254]

### How do I build release app on iOS?

If you are not deploying the application, you probably don't need to build it in release mode. For performance testing use profile mode which is as much efficient as release mode.
If you want to deploy the app, check out Fastlane instructions below.

If you really want to run app locally with `release` mode, change in xcode `Automatically manage signing` to true for Runner and ImageNotification targets (in Signing&Capabilities tab).

## Mobile introduction.

- Backend doker : https://github.com/informedtechnologies/odin
- Mobile app : https://github.com/informedtechnologies/nanna
- Task Tack: https://linear.app/informed/view/8991277e-01fd-4264-a7a0-6aab45719535

* [ ] Mobile app stack:

- Flutter : 2.10.1 (for Flutter version management we are using FVM https://fvm.app/, but it isn't required)
- Navigation : auto_route
- Immutable data class : freezed
- Logs: fimber
- DI: injectable + getIt
- Parsing : json_annotation
- Language and Texts : easy_localization
- State management : Cubit (bloc)
- Animations and controllers : flutter_hooks
- GraphQl : graphql_flutter
- Firebase and more in the pubspec :slightly_smiling_face:

* [ ] Workflow:

  Basically we are going with git flow. So we have master, develop (our main branch) and we are creating branches per task, with prefix feature/

  So when you go to Linear -> Create task, you can click "Copy git branch name to clipboard" and later create branch like that "feature/inf-135-share-reading-list"

  When you create Merge request, post URL to you MR on this channel and we will check it. To merge request we have to have at least one approve.

* [ ] Project Architecture:
      Clean Architecture - TLDR. Split architecture into 3 layers for separation of UI, Business logic and Implementation.

      User --> UI --> Business Logic --> Data access ---> Data source

- [ ] Basically we split app in the 3 layers (4 folders).

* DataAccess Layer --> Core and Data folder (core - only di, data whole app infrastructure, fetching data ect.)
  In this layer we have DTO data objects.

* Domain - domain folder (use cases, data classes (mapped DTO classes)
  UseCases should have only one Purpose. If you need few actions on your cubit, you will inject few usecases.
  Doing this we are more flexible and we can implement any feature in any place. (You can look at the code to get the idea)

* Presentation - UI --> all views, pages, widgets, app styling.
  In folder page we have all the view, we split features into folders.
  Basic feature consists of
  page
  state
  cubit

- [ ] How do we change app state?

(Spoiler: similar to MVVM :slightly_smiling_face: , where cubit is like view model)
In UI we have access to cubit, we called specific method from cubit, than we get a response, then we in the cubit we Emit specific state based on result. The State is Freezed data class, so immutable dataclass is representing our app state.
all states for specific page (view) are defined in XXX_state file.

Example:

```
    MyReadsPageState - initialLoading, idle
    @freezed
    class MyReadsPageState with _$MyReadsPageState {
    @Implements<BuildState>()
    factory MyReadsPageState.initialLoading() = _MyReadsPageStateInitialLoading;

    @Implements<BuildState>()
    factory MyReadsPageState.idle(MyReadsContent content) = _MyReadsPageStateIdle;
    }
```

on the view are listening for cubit emission, and we are changing UI accordingly.
example:

```
    Expanded(
        child: state.maybeMap(
            initialLoading: (_) => const Loader(),
            idle: (state) => _Idle(content: state.content),
            orElse: () => const SizedBox.shrink(),
        ),
    ),
```

- Hint, you can spend some time and read cubit_hooks.dart file in our project. Because in there we have our own custom hooks for cubits.
  When we create public widgets we use named parameters.

## Fastlane

In case you need to deploy application using your local machine, you will need few things:

- fastlane-ios-pass file containing passphrase you will need to decode certs that are stored in GitHub
- password for `engineering-cd@betterinformed.io` Apple ID

Next step is to go to `ios` folder and run `fastlane match appstore --readonly` command and follow instructions. You will end up with all certs and provisioning profiles stored on your machine. Only thing left is archive the app and deploy it.

## Unit testing

Not much to add to basic unit tests building, only that for app specific unit tests, we have some tools to ease its building:

```
void main() {
  testWidgets(
    'sign in with apple button shows on apple device',
    (tester) async {
      kIsAppleDevice = true;
      await tester.startApp(initialRoute: const SignInPageRoute());
      expect(find.byText(LocaleKeys.signIn_providerButton_apple.tr()), findsOneWidget);
    },
  );
...
```

## Important:

All tests must be referenced in the file `test/unit/wrapper_test.dart` in order to be picked up by our CI workflows

The `startApp` command ensures that all assets and navigation are set up and loaded before running any other test commands on the app

Make sure to use `setUp` and `tearDown` commands as needed for each test - to change or revert any config changes made for specific tests

```
...
  testWidgets(
    'dialog shows up when app is outdated',
    (tester) async {
      // Forcing dialog to show because fetching and solving version logic is already tested by package
      Upgrader().debugDisplayAlways = true;
      await tester.startApp();
      expect(find.byText(LocaleKeys.update_title.tr()), findsOneWidget);
    },
  );

  tearDown(() {
    Upgrader().debugDisplayAlways = false;
  });
...
```

## Golden image Testing

Visual testing is comparing a specific app state with a golden state, created at some point in the past

Our aim is to have a visual test for every screen we have in the app, and in the case of complex ones, several golden images covering their most important states.

So, for the `ExplorePage` screen, we will have

```
void main() {
  visualTest(ExplorePage, (tester) async {
    await tester.startApp(initialRoute: const ExploreTabGroupRouter(children: [ExplorePageRoute()]));
    await tester.matchGoldenFile();
  });
}
```

### Notes:

1. All golden image tests must be referenced in the file `test/visual/wrapper_test.dart`, otherwise it will not be picked up in our CI worklflows
1. There is no need to `pumpAndSettle` after calling `startApp`, since it's already done inside it
1. The first parameter of the `visualTest` method is the name of the test, which will be used for the golden image name if not set explicitly in `matchGoldenFile()`
1. To create 2 or more golden images in the same tet (to reflect different parts or states of a same screen in a single test), you can set a custom golden file name with the same prefix in all and indicating the difference in parenthesis, as in:

```
  visualTest(MediaItemPage, (tester) async {
    await tester.startApp(initialRoute: MainPageRoute(children: [MediaItemPageRoute(slug: '')]));

    await tester.matchGoldenFile('media_item_page_(image)');

    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile('media_item_page_(content)');
  });
```

4. Each test creates 4 golden images, each for 4 different device sizes (see `defaultDevices` in `visual_test_utils.dart`). To overwrite this behavior, use the `testConfig` parameter in the `visualTest` method:

```
  visualTest(
    TopicOwnerPage,
    (tester) async {
      ...
    },
    testConfig: TestConfig.unitTesting.withDevices([highDevice]),
  );
```

5. The `screens_report` command groups all golden images of different sizes into a single file. If you need to group different images into a single file, use the same name for all and indicate its difference with a `.` instead of `()`, as in:

```
 visualTest(
    QuoteForegroundView,
    (tester) async {
      ...
      // By specifying the variant with a dot (.linen), the screens_report command will group all of them in a single image
      await tester.matchGoldenFile('quote_foreground_view.linen');
      ...
      await tester.matchGoldenFile('quote_foreground_view.rose');
      ...
```

The aim to figure out what has changed in our branch, is to compare the app's state in the develop branch, with the app's state in our branch.

So, until this is automated, the steps to achieve this are:

1. Checkout develop branch
2. Create the golden images -- run `make update_goldens`. You can see the output in `test/visual/goldens`. You can use `make screens_report` after creating the goldens, for an grouped-by-screen version of all available goldens in `test/visual/screens_report`
3. Checkout the work in progress branch
4. Compare with the created golden images -- run `flutter test test/visual/wrapper_test.dart`
5. If there are any differences, the folder `test/visual/failures` will be created, with the before/after files, and the isolated and combine differences

More functionality to come for this feature!
