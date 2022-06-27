import 'package:better_informed_mobile/domain/image/data/image.dart';

class Publisher {
  Publisher({
    required this.name,
    required this.lightLogo,
    required this.darkLogo,
  });
  final String name;
  final Image? lightLogo;
  final Image? darkLogo;
}
