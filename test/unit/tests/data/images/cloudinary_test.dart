import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../unit_test_utils.dart';

final cloudName = AppConfig.mock.cloudinaryCloudName;
final baseUrl = 'https://res.cloudinary.com/$cloudName/image/upload/c_fill,g_auto,q_auto/';
final androidExtension = '.${ImageType.webp.name}';
final iOSExtension = '.${ImageType.jpg.name}';

void main() {
  test(
    'generates url from a publicId with a simple name, no subfolder',
    () {
      const publicId = 'imageName';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

      expect(url, equals('$baseUrl$publicId'));
    },
  );
  test('generates url from a publicId with a simple name, 1 subfolder', () {
    const publicId = 'subfolder/imageName';
    final image = CloudinaryImage.fromPublicId(cloudName, publicId);
    final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

    expect(url, equals('$baseUrl$publicId'));
  });
  test('generates url from a publicId with a simple name, +1 subfolders', () {
    const publicId = 'subfolder1/subfolder2/imageName';
    final image = CloudinaryImage.fromPublicId(cloudName, publicId);
    final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

    expect(url, equals('$baseUrl$publicId'));
  });
  test('generates url from a publicId with a . in the name, no subfolder', () {
    const publicId = 'imageName.With.Dots';
    final image = CloudinaryImage.fromPublicId(cloudName, publicId);
    final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

    expect(url, equals('$baseUrl$publicId'));
  });
  test('generates url from a publicId with a . in the name, 1 subfolder', () {
    const publicId = 'subfolder/imageName.With.Dots';
    final image = CloudinaryImage.fromPublicId(cloudName, publicId);
    final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

    expect(url, equals('$baseUrl$publicId'));
  });
  test('generates url from a publicId with a . in the name, +1 subfolders', () {
    const publicId = 'subfolder1/subfolder2/imageName.With.Dots';
    final image = CloudinaryImage.fromPublicId(cloudName, publicId);
    final url = image.transform().autoGravity().autoQuality().generateNotNull(publicId);

    expect(url, equals('$baseUrl$publicId'));
  });

  testWidgets(
    'generates url from a publicId with a simple name, no subfolder, platform extension',
    (tester) async {
      const publicId = 'imageName';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );

  testWidgets(
    'generates url from a publicId with a simple name, 1 subfolder, platform extension',
    (tester) async {
      const publicId = 'subfolder/imageName';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );
  testWidgets(
    'generates url from a publicId with a simple name, +1 subfolders, platform extension',
    (tester) async {
      const publicId = 'subfolder1/subfolder2/imageName';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );
  testWidgets(
    'generates url from a publicId with a . in the name, no subfolder, platform extension',
    (tester) async {
      const publicId = 'imageName.With.Dots';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );
  testWidgets(
    'generates url from a publicId with a . in the name, 1 subfolder, platform extension',
    (tester) async {
      const publicId = 'subfolder/imageName.With.Dots';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );
  testWidgets(
    'generates url from a publicId with a . in the name, +1 subfolders, platform extension',
    (tester) async {
      const publicId = 'subfolder1/subfolder2/imageName.With.Dots';
      final image = CloudinaryImage.fromPublicId(cloudName, publicId);
      final url = image.transform().autoGravity().autoQuality().generateAsPlatform(publicId);

      if (kIsAppleDevice) {
        expect(url, equals('$baseUrl$publicId$iOSExtension'));
      } else {
        expect(url, equals('$baseUrl$publicId$androidExtension'));
      }
    },
    variant: informedPlatformsVariant,
  );
}
