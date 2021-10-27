import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/reading_banner.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/article/article_page_data.dart';
import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _iconSize = 80.0;

class ReadingBannerView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ReadingBannerCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize();
    }, [cubit]);

    return state.maybeMap(
      notVisible: (state) => const SizedBox(),
      visible: (state) => _ReadingBannerBody(state.readingBanner),
      orElse: () => const SizedBox(),
    );
  }
}

class _ReadingBannerBody extends HookWidget {
  final ReadingBanner readingBanner;

  const _ReadingBannerBody(this.readingBanner, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = readingBanner.entry.item.image?.publicId;

    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(
          ArticlePageRoute(
            pageData: ArticlePageData.singleArticle(
              entry: readingBanner.entry,
              readArticleProgress: readingBanner.scrollProgress,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: AppColors.lightGrey,
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
                    child: imageId != null
                        ? Image.network(
                            cloudinaryProvider
                                .withPublicId(imageId)
                                .transform()
                                .withLogicalSize(_iconSize, _iconSize, context)
                                .autoGravity()
                                .generateNotNull(),
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
                            style: AppTypography.subH2RegularSmall.copyWith(color: AppColors.greyFont, height: 1),
                          ),
                          const SizedBox(height: AppDimens.s),
                          Text(
                            readingBanner.entry.item.title,
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
