import 'package:better_informed_mobile/domain/daily_brief/data/call_to_action.dart';

class Relax {
  Relax({
    required this.message,
    required this.icon,
    required this.callToAction,
    required this.headline,
  });

  final String? icon;
  final String headline;
  final String message;
  final CallToAction? callToAction;
}
