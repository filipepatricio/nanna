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