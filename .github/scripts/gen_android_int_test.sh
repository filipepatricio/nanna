#!/bin/bash

B64_ENV=$(echo env=prod | base64)
B64_ACCESS_TOKEN=$(echo accessToken=$ACCESS_TOKEN | base64)

flutter build apk --debug --flavor prod --dart-define=env=prod

cd android
./gradlew app:assembleProdDebugAndroidTest
./gradlew app:assembleProdDebug -Ptarget=$(pwd)/../integration_test/main_test.dart -Pdart-defines="$B64_ENV,$B64_ACCESS_TOKEN"
cd ..
