# Nanna

Nanna is our Flutter-based mobile app named after [Nanna](https://en.wikipedia.org/wiki/Nanna_(Norse_deity)) from Norse mythology. She is associated with joy, peace and the moon, and the name Nanna probably derives from "Mother". Thus, this is a fitting name for our mother of apps.

## Getting Started

Follow those steps to start:

- Make sure you have installed Flutter 2.2.3 (for Flutter version management we are using FVM https://fvm.app/, but it isn't required)
- Run `flutter pub get` to get dependencies
- Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate code (routing, json serializers etc.)
- Run `fvm flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart` to generate translation files

...and you are ready to go.

## Running App

Right now we have 3 app flavors: dev, stage and prod. This adds requirement for additional arguments when running flutter app:

`flutter run --release --dart-define=env=dev --flavor dev`

If you want to set custom api host, that application connects to, just include additional argument in run command:

`--dart-define=host=http://127.0.0.1:4000/graphql`

## Project Setup Troubleshoot

- [ ]  Problem Sign in with Google:

* Add the `key_<env>.properties` files on the `/android` folder
* Add the `informed.keystore` to an external folder and edit `key_<env>.properties` files `storeFile=` property to have the path of the `informed.keystore`

- [ ]  Bug Sign in with Apple on iOS simulator:

* [https://developer.apple.com/forums/thread/651533](https://developer.apple.com/forums/thread/651533?page=3)

- [ ]  Sign in with provider - SocketException: OS Error: Connection refused, errno = 111

* Start app with:

```—dart-define=host=http://<your machine ip on the network>:4000/graphql```

* [https://fluttercorner.com/socketexception-os-error-connection-refused-errno-111-in-flutter/](https://fluttercorner.com/socketexception-os-error-connection-refused-errno-111-in-flutter/)
