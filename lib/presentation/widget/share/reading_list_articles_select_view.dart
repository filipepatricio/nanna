import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/date_helper.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _articlesInArRow = 3;
const _articlesItemAspectRatio = 10 / 15;
const _articlePublisherImageSize = 120;
const _articlePublisherIconSize = 20.0;

Future<void> shareReadingList(BuildContext context, Topic topic) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ReadingListArticlesSelectView(topic: topic),
    ),
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
  );
}

class ReadingListArticlesSelectView extends HookWidget {
  final Topic topic;

  const ReadingListArticlesSelectView({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ReadingListArticlesSelectViewCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<ReadingListArticlesSelectViewCubit, ReadingListArticlesSelectViewState>(
      cubit,
      (cubit, state, context) {
        state.maybeMap(
          shared: (_) {
            AutoRouter.of(context).pop();
          },
          orElse: () {},
        );
      },
    );

    useEffect(
      () {
        cubit.initialize(topic);
      },
      [cubit],
    );

    return Material(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimens.shareBottomSheetRadius),
      ),
      color: const Color(0xffF5F5F5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          const _Header(),
          const SizedBox(height: AppDimens.m),
          const Divider(height: 0.5, color: AppColors.greyDividerColor),
          const SizedBox(height: AppDimens.s),
          Expanded(
            child: state.maybeMap(
              initializing: (_) => const _ProcessingView(),
              generatingShareImage: (_) => const _ProcessingView(),
              idle: (state) => _IdleView(
                cubit: cubit,
                articles: state.articles,
                selectedIndexes: state.selectedIndexes,
                canSelectMore: state.canSelectMore,
                maxArticles: state.articlesSelectionLimit,
              ),
              orElse: () => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Loader(),
    );
  }
}

class _IdleView extends StatelessWidget {
  final ReadingListArticlesSelectViewCubit cubit;
  final List<ArticleHeader> articles;
  final Set<int> selectedIndexes;
  final bool canSelectMore;
  final int maxArticles;

  const _IdleView({
    required this.cubit,
    required this.articles,
    required this.selectedIndexes,
    required this.canSelectMore,
    required this.maxArticles,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _ArticlesGridView(
              cubit: cubit,
              articles: articles,
              selectedIndexes: selectedIndexes,
              canSelectMore: canSelectMore,
            ),
          ),
          const SizedBox(height: AppDimens.s),
          Center(
            child: Text(
              LocaleKeys.shareTopic_selectedLabel.tr(
                args: [
                  selectedIndexes.length.toString(),
                  maxArticles.toString(),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: FilledButton(
              onTap: () => cubit.generateShareImage(),
              text: LocaleKeys.common_next.tr(),
            ),
          ),
          const SizedBox(height: AppDimens.m),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.shareTopic_title.tr()),
                Text(
                  LocaleKeys.shareTopic_amountInfo.tr(
                    args: [articlesSelectionLimit.toString()],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _ArticlesGridView extends StatelessWidget {
  final ReadingListArticlesSelectViewCubit cubit;
  final List<ArticleHeader> articles;
  final Set<int> selectedIndexes;
  final bool canSelectMore;

  const _ArticlesGridView({
    required this.cubit,
    required this.articles,
    required this.selectedIndexes,
    required this.canSelectMore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.m),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _articlesInArRow,
        childAspectRatio: _articlesItemAspectRatio,
        crossAxisSpacing: AppDimens.s,
        mainAxisSpacing: AppDimens.s,
      ),
      itemBuilder: (context, index) => _ArticleItemView(
        cubit: cubit,
        index: index,
        header: articles[index],
        selected: selectedIndexes.contains(index),
        canSelectMore: canSelectMore,
      ),
      itemCount: articles.length,
    );
  }
}

class _ArticleItemView extends StatelessWidget {
  final ReadingListArticlesSelectViewCubit cubit;
  final int index;
  final ArticleHeader header;
  final bool selected;
  final bool canSelectMore;

  const _ArticleItemView({
    required this.cubit,
    required this.index,
    required this.header,
    required this.selected,
    required this.canSelectMore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = header.image?.publicId;
    final selectionEnabled = selected || canSelectMore;

    return InkWell(
      onTap: selectionEnabled ? _onTap : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.xs),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(AppDimens.zero, AppDimens.topicCardOffsetY),
                  blurRadius: AppDimens.s,
                  color: AppColors.shadowColor,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.xs),
              child: Container(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Image.network(
                        CloudinaryImageExtension.withPublicId(imageUrl ?? '')
                            .url, // TODO: what to do in case of missing image
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppDimens.s),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimens.xs),
                        child: Text(
                          header.title,
                          style: AppTypography.metadata1Regular.copyWith(height: 1.25),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.s),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimens.xs, horizontal: AppDimens.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateHelper.shortDate(header.publicationDate) +
                                ' · ' +
                                LocaleKeys.article_readMinutes.tr(
                                  args: [
                                    header.timeToRead.toString(),
                                  ],
                                ),
                            style: AppTypography.metadata1Regular.copyWith(fontSize: 7.5),
                          ),
                          const Spacer(),
                          Image.network(
                            CloudinaryImageExtension.withPublicId(header.publisher.logo.publicId)
                                .transform()
                                .width(_articlePublisherImageSize)
                                .fit()
                                .generate()!,
                            fit: BoxFit.contain,
                            width: _articlePublisherIconSize,
                            height: _articlePublisherIconSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // TODO: adjust designs when ready
            top: AppDimens.s,
            right: AppDimens.s,
            child: selectionEnabled
                ? Icon(
                    selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    if (selected) {
      cubit.unselectArticle(index);
    } else {
      if (canSelectMore) {
        cubit.selectArticle(index);
      }
    }
  }
}
