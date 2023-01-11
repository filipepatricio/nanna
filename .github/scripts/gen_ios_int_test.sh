#!/bin/sh

output="../build/ios_integ"
product="build/ios_integ/Build/Products"
scheme="prod"

flutter build ios --config-only --release --flavor ${scheme} --dart-define=env=integration_prod --dart-define=accessToken=$ACCESS_TOKEN integration_test/main_test.dart

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme $scheme -config Release-${scheme} -derivedDataPath $output -sdk iphoneos -arch "arm64" build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-${scheme}-iphoneos" *.xctestrun
popd
