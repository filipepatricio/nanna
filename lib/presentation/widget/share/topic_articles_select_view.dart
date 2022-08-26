import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/share/data/share_app.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _articlesInArRow = 3;
const _articleItemHeight = 150.0;

const _iosBackgroundColor = Color(0xffF5F5F5);
const _labelColor = Color(0xFF8D8D8D);
const _labelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 13,
  color: _labelColor,
  height: 1.4,
);

Future<void> shareTopicArticlesList(
  BuildContext context,
  Topic topic,
  ShareOptions? shareOption,
  SnackbarController snackbarController,
) async {
  if (shareOption == null) return;

  return _showBottomSheet(
    context,
    (context) => TopicArticlesSelectView(
      topic: topic,
      shareOption: shareOption,
      snackbarController: snackbarController,
    ),
  );
}

Future<void> _showBottomSheet(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: builder(context),
    ),
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
  );
}

class TopicArticlesSelectView extends HookWidget {
  const TopicArticlesSelectView({
    required this.topic,
    required this.shareOption,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final ShareOptions shareOption;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicArticlesSelectViewCubit>();
    final state = useCubitBuilder(cubit);

    useCubitListener<TopicArticlesSelectViewCubit, TopicArticlesSelectViewState>(
      cubit,
      (cubit, state, context) {
        state.maybeMap(
          shared: (_) {
            AutoRouter.of(context).pop();

            if (shareOption == ShareOptions.copyLink) {
              snackbarController.showMessage(
                SnackbarMessage.simple(
                  message: LocaleKeys.common_linkCopied.tr(),
                  type: SnackbarMessageType.positive,
                ),
              );
            }
          },
          orElse: () {},
        );
      },
    );

    useEffect(
      () {
        cubit.initialize(topic);

        if (shareOption != ShareOptions.instagram && shareOption != ShareOptions.facebook) {
          cubit.shareImage(shareOption);
        }
      },
      [cubit],
    );

    final contentView = state.maybeMap(
      initializing: (_) => const _ProcessingView(),
      generatingShareImage: (_) => const _ProcessingView(),
      idle: (state) => _IdleView(
        cubit: cubit,
        articles: state.articles,
        selectedIndexes: state.selectedIndexes,
        canSelectMore: state.canSelectMore,
        maxArticles: state.articlesSelectionLimit,
        shareOption: shareOption,
      ),
      orElse: () => const SizedBox.shrink(),
    );

    if (kIsAppleDevice) {
      return _ContainerIOS(child: contentView);
    } else {
      return _ContainerAndroid(
        selectedArticles: state.maybeMap(
          idle: (state) => state.selectedIndexes.length,
          orElse: () => null,
        ),
        maxArticles: state.maybeMap(
          idle: (state) => state.articlesSelectionLimit,
          orElse: () => null,
        ),
        child: contentView,
      );
    }
  }
}

class _ContainerIOS extends StatelessWidget {
  const _ContainerIOS({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimens.shareBottomSheetRadius),
      ),
      color: _iosBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.m),
          const _IOSHeader(),
          const SizedBox(height: AppDimens.m),
          const Divider(height: 0.5, color: AppColors.dividerGreyLight),
          const SizedBox(height: AppDimens.s),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ContainerAndroid extends StatelessWidget {
  const _ContainerAndroid({
    required this.selectedArticles,
    required this.maxArticles,
    required this.child,
    Key? key,
  }) : super(key: key);
  final int? selectedArticles;
  final int? maxArticles;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          _AndroidHeader(
            selectedArticles: selectedArticles,
            maxArticles: maxArticles,
          ),
          const SizedBox(height: AppDimens.l),
          Expanded(child: child),
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

class _IdleView extends HookWidget {
  const _IdleView({
    required this.cubit,
    required this.articles,
    required this.selectedIndexes,
    required this.canSelectMore,
    required this.maxArticles,
    required this.shareOption,
    Key? key,
  }) : super(key: key);
  final TopicArticlesSelectViewCubit cubit;
  final List<MediaItemArticle> articles;
  final Set<int> selectedIndexes;
  final bool canSelectMore;
  final int maxArticles;
  final ShareOptions shareOption;

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
          if (kIsAppleDevice)
            Center(
              child: Text(
                LocaleKeys.shareTopic_selectedLabel.tr(
                  args: [
                    selectedIndexes.length.toString(),
                    maxArticles.toString(),
                  ],
                ),
                style: _labelTextStyle,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m, vertical: AppDimens.m),
            child: FilledButton(
              onTap: () => cubit.shareImage(shareOption),
              text: LocaleKeys.common_next.tr(),
              fillColor: AppColors.charcoal,
              textColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _AndroidHeader extends StatelessWidget {
  const _AndroidHeader({
    required this.selectedArticles,
    required this.maxArticles,
    Key? key,
  }) : super(key: key);
  final int? selectedArticles;
  final int? maxArticles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.shareTopic_title.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.black,
              height: 1.33,
            ),
          ),
          const SizedBox(height: AppDimens.s),
          Visibility(
            visible: selectedArticles != null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Text(
              LocaleKeys.shareTopic_selectedLabel.tr(
                args: [
                  selectedArticles.toString(),
                  maxArticles.toString(),
                ],
              ),
              style: _labelTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _IOSHeader extends StatelessWidget {
  const _IOSHeader({Key? key}) : super(key: key);

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
                Text(
                  LocaleKeys.shareTopic_title.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.black,
                    height: 1.33,
                  ),
                ),
                Text(
                  LocaleKeys.shareTopic_amountInfo.tr(
                    args: [articlesSelectionLimit.toString()],
                  ),
                  style: _labelTextStyle,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => AutoRouter.of(context).pop(),
            child: SvgPicture.asset(AppVectorGraphics.closeIOS),
          ),
        ],
      ),
    );
  }
}

class _ArticlesGridView extends StatelessWidget {
  const _ArticlesGridView({
    required this.cubit,
    required this.articles,
    required this.selectedIndexes,
    required this.canSelectMore,
    Key? key,
  }) : super(key: key);
  final TopicArticlesSelectViewCubit cubit;
  final List<MediaItemArticle> articles;
  final Set<int> selectedIndexes;
  final bool canSelectMore;

  @override
  Widget build(BuildContext context) {
    final scrollController = ModalScrollController.of(context);

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.m, vertical: AppDimens.m),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _articlesInArRow,
        mainAxisExtent: _articleItemHeight,
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
  const _ArticleItemView({
    required this.cubit,
    required this.index,
    required this.header,
    required this.selected,
    required this.canSelectMore,
    Key? key,
  }) : super(key: key);
  final TopicArticlesSelectViewCubit cubit;
  final int index;
  final MediaItemArticle header;
  final bool selected;
  final bool canSelectMore;

  @override
  Widget build(BuildContext context) {
    final selectionEnabled = selected || canSelectMore;

    return GestureDetector(
      onTap: selectionEnabled ? _onTap : null,
      child: Stack(
        children: [
          Container(
            color: AppColors.mockedColors[index % AppColors.mockedColors.length],
          ),
          Positioned.fill(
            child: _ArticleItemBody(header: header),
          ),
          Positioned(
            top: AppDimens.s,
            right: AppDimens.s,
            child: _SelectionCircle(
              selected: selected,
            ),
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

class _ArticleItemBody extends HookWidget {
  const _ArticleItemBody({
    required this.header,
    Key? key,
  }) : super(key: key);
  final MediaItemArticle header;

  @override
  Widget build(BuildContext context) {
    final logoUrl = header.publisher.darkLogo;
    final timeToRead = header.timeToRead;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.xl),
          if (logoUrl != null)
            PublisherLogo.dark(
              publisher: header.publisher,
              dimension: AppDimens.m,
            )
          else
            Container(
              height: AppDimens.m,
            ),
          const SizedBox(height: AppDimens.s),
          InformedMarkdownBody(
            markdown: header.title,
            baseTextStyle: AppTypography.subH2Bold,
            maxLines: 4,
            highlightColor: AppColors.transparent,
          ),
          const Spacer(),
          if (timeToRead != null) ...[
            Text(
              tr(
                LocaleKeys.article_readMinutes,
                args: [
                  header.timeToRead.toString(),
                ],
              ),
              style: AppTypography.labelText,
            ),
            const SizedBox(height: AppDimens.s),
          ],
        ],
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({required this.selected, Key? key}) : super(key: key);
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      selected ? AppVectorGraphics.shareSelected : AppVectorGraphics.shareNotSelected,
      width: AppDimens.l,
      height: AppDimens.l,
    );
  }
}
