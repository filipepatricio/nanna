import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void replaceToEntry() {
    if (mounted) router.replaceAll([const EntryPageRoute()]);
  }

  void replaceToMain() {
    if (mounted) router.replaceAll([const MainPageRoute()]);
  }

  void resetToEntry() {
    if (mounted) router.pushAndPopUntil(const EntryPageRoute(), predicate: (_) => false);
  }

  void resetToMain() {
    if (mounted) router.pushAndPopUntil(const MainPageRoute(), predicate: (_) => false);
  }

  void resetToSignIn() {
    if (mounted) router.pushAndPopUntil(const SignInPageRoute(), predicate: (_) => false);
  }

  void resetToOnboarding() {
    if (mounted) router.pushAndPopUntil(const OnboardingPageRoute(), predicate: (_) => false);
  }
}
