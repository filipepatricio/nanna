import 'package:better_informed_mobile/domain/image/data/image.dart';

class Publisher {
  final String name;
  final CloudinaryImage? lightLogo;
  final CloudinaryImage? darkLogo;

  Publisher({
    required this.name,
    required this.lightLogo,
    required this.darkLogo,
  });
}
