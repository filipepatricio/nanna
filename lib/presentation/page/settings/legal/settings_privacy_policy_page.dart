import 'package:better_informed_mobile/domain/legal_page/data/legal_page_type.dart';
import 'package:better_informed_mobile/presentation/page/settings/legal/settings_legal_page_page.dart';
import 'package:flutter/material.dart';

class SettingsPrivacyPolicyPage extends StatelessWidget {
  const SettingsPrivacyPolicyPage({this.fromRoute});

  final String? fromRoute;

  @override
  Widget build(BuildContext context) {
    return SettingsLegalPagePage(
      type: LegalPageType.privacyPolicy,
      fromRoute: fromRoute,
    );
  }
}
