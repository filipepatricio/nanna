import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Loader(),
          TextButton(
            onPressed: () => AutoRouter.of(context).push(const DailyBriefPageRoute()),
            child: const Text('Daily brief'),
          ),
          const SizedBox(height: AppDimens.l),
          TextButton(
            onPressed: () => AutoRouter.of(context).push(const OnboardingPageRoute()),
            child: const Text('Onboarding.'),
          ),
          const SizedBox(height: AppDimens.l),
          TextButton(
            onPressed: () => AutoRouter.of(context).push(const MainPageRoute()),
            child: const Text('MainPage'),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
