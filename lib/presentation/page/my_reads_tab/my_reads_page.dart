import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyReadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReadingBannerWrapper(
      child: Scaffold(
        appBar: InformedAppBar(
          title: LocaleKeys.main_myReadsTab.tr(),
          isTriangleShape: true,
          showSettingsIcon: true,
        ),
        backgroundColor: AppColors.lightGrey,
        body: Container(
          child: const Center(
            child: Text('My reads tab'),
          ),
        ),
      ),
    );
  }
}
