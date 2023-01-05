#!/bin/bash

B64_ENV=$(echo -n "env=integration" | base64 -w 0)
B64_ACCESS_TOKEN=$(echo -n "accessToken=$ACCESS_TOKEN" | base64 -w 0)

flutter build apk --debug --flavor prod --dart-define=env=integration --dart-define=accessToken=$ACCESS_TOKEN

cd android
./gradlew app:assembleProdDebugAndroidTest -Ptarget=$(pwd)/../integration_test/main_test.dart -Pdart-defines="$B64_ENV,$B64_ACCESS_TOKEN"
./gradlew app:assembleProdDebug -Ptarget=$(pwd)/../integration_test/main_test.dart -Pdart-defines="$B64_ENV,$B64_ACCESS_TOKEN"
cd ..
