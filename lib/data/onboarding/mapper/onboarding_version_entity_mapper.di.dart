import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';
import 'package:injectable/injectable.dart';

const _v1Code = 0;
const _v2Code = 1;

@injectable
class OnboardingVersionEntityMapper implements BidirectionalMapper<int, OnboardingVersion> {
  @override
  int from(OnboardingVersion version) {
    switch (version) {
      case OnboardingVersion.v1:
        return _v1Code;
      case OnboardingVersion.v2:
        return _v2Code;
    }
  }

  @override
  OnboardingVersion to(int versionCode) {
    switch (versionCode) {
      case _v1Code:
        return OnboardingVersion.v1;
      case _v2Code:
        return OnboardingVersion.v2;
    }

    throw ArgumentError.value(versionCode, 'version', 'Unknown version code');
  }
}
