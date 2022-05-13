import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _iconSize = 80.0;

class ReadingBannerView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ReadingBannerCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return state.maybeMap(
      notVisible: (state) => const SizedBox(),
      visible: (state) => _ReadingBannerBody(state.readingBanner),
      orElse: () => const SizedBox(),
    );
  }
}

class _ReadingBannerBody extends StatelessWidget {
  final ReadingBanner readingBanner;

  const _ReadingBannerBody(this.readingBanner);

  @override
  Widget build(BuildContext context) {
    final hasImage = readingBanner.article.hasImage;

    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(
          MediaItemPageRoute(
            article: readingBanner.article,
            readArticleProgress: readingBanner.scrollProgress,
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                minHeight: AppDimens.xs,
                value: readingBanner.scrollProgress,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.limeGreen),
                backgroundColor: AppColors.limeGreen.withOpacity(0.44),
              ),
              Row(
                children: [
                  Container(
                    width: _iconSize,
                    height: _iconSize,
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    child: hasImage
                        ? ArticleImage(
                            image: readingBanner.article.image!,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(width: AppDimens.s),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppDimens.m),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            LocaleKeys.continueReading.tr(),
                            style: AppTypography.subH2Regular.copyWith(color: AppColors.textGrey, height: 1),
                          ),
                          const SizedBox(height: AppDimens.s),
                          Text(
                            readingBanner.article.title,
                            style: AppTypography.h5BoldSmall.copyWith(height: 1),
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
