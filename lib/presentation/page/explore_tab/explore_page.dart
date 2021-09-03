import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/informed_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: ReadingBannerWrapper(
        child: Scaffold(
          appBar: InformedAppBar(
            title: LocaleKeys.main_exploreTab.tr(),
            isTriangleShape: false,
          ),
          backgroundColor: AppColors.lightGrey,
          body: Container(
            child: const Center(
              child: Text('Explore tab'),
            ),
          ),
        ),
      ),
    );
  }
}
