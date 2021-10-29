import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';

class Publisher {
  final String name;
  final Image? lightLogo;
  final Image? darkLogo;

  Publisher({
    required this.name,
    required this.lightLogo,
    required this.darkLogo,
  });
}
