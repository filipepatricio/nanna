import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ReadingBannerPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ReadingBannerCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return state.maybeMap(
      notVisible: (state) => Container(),
      visible: (state) => _ReadingBannerBody(state.readingBanner),
      orElse: () => Container(),
    );
  }
}

class _ReadingBannerBody extends StatelessWidget {
  final ReadingBanner readingBanner;

  const _ReadingBannerBody(this.readingBanner, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: do this when wrapper will be in cupertinoScaffold
        // CupertinoScaffold.showCupertinoModalBottomSheet(
        //   context: context,
        //   builder: (context) => ArticlePage(article: readingBanner.article),
        //   useRootNavigator: true,
        // );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: AppColors.lightGrey,
          height: AppDimens.readingBannerHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                minHeight: AppDimens.xxs,
                value: readingBanner.scrollProgress,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.limeGreen),
                backgroundColor: AppColors.limeGreen.withOpacity(0.44),
              ),
              Row(
                children: [
                  Container(
                    width: AppDimens.xxxl,
                    height: AppDimens.xxxl,
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    child: Image.asset(readingBanner.article.sourceUrl, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: AppDimens.s),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppDimens.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.continueReading.tr(),
                            style: AppTypography.subH2RegularSmall.copyWith(color: AppColors.greyFont),
                          ),
                          Text(
                            readingBanner.article.title,
                            style: AppTypography.h5BoldSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
