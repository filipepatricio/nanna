import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/expand_tap_area/expand_tap_area.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _loaderSize = 16.0;
const _loaderStroke = 2.0;
const _iconSize = 32.0;
const _animationDuration = 100;

class BookmarkButton extends HookWidget {
  BookmarkButton.article({
    required MediaItemArticle article,
    Color color = AppColors.charcoal,
    String? topicId,
    String? briefId,
    SnackbarController? snackbarController,
    double? iconSize,
    Key? key,
  }) : this._(
          BookmarkTypeData.article(article.slug, article.id, topicId, briefId),
          color: color,
          snackbarController: snackbarController,
          iconSize: iconSize,
          key: key,
        );

  BookmarkButton.topic({
    required TopicPreview topic,
    Color color = AppColors.charcoal,
    String? briefId,
    SnackbarController? snackbarController,
    double? iconSize,
    Key? key,
  }) : this._(
          BookmarkTypeData.topic(topic.slug, topic.id, briefId),
          color: color,
          snackbarController: snackbarController,
          iconSize: iconSize,
          key: key,
        );

  const BookmarkButton._(
    this._data, {
    required this.color,
    this.snackbarController,
    this.iconSize,
    Key? key,
  }) : super(key: key);

  final BookmarkTypeData _data;
  final Color color;
  final SnackbarController? snackbarController;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<BookmarkButtonCubit>();
    final state = useCubitBuilder(cubit);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: _animationDuration),
    );

    useCubitListener<BookmarkButtonCubit, BookmarkButtonState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          bookmarkAdded: (_) {
            snackbarController?.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.bookmark_addBookmarkSuccess),
                type: SnackbarMessageType.positive,
              ),
            );
          },
          bookmarkRemoved: (value) {
            snackbarController?.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.bookmark_removeBookmarkSuccess),
                type: SnackbarMessageType.positive,
                action: SnackbarAction(
                  label: tr(LocaleKeys.common_undo),
                  callback: () {
                    cubit.switchState(fromUndo: true);
                  },
                ),
              ),
            );
          },
        );
      },
    );

    useEffect(
      () {
        cubit.initialize(_data);
      },
      [cubit, _data],
    );

    return ScaleTransition(
      scale: kIsTest
          ? const AlwaysStoppedAnimation(1.0)
          : Tween(begin: 1.0, end: 1.4).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.bounceInOut,
              ),
            ),
      child: SizedBox.square(
        dimension: iconSize ?? _iconSize,
        child: Container(
          padding: EdgeInsets.zero,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: _animationDuration),
              child: state.maybeMap(
                initializing: (_) => const _Loader(),
                idle: (state) => _IdleButton(
                  cubit: cubit,
                  state: state.state,
                  color: color,
                  animationController: animationController,
                ),
                switching: (state) => const _Loader(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: _loaderSize,
      child: Loader(
        color: AppColors.charcoal,
        strokeWidth: _loaderStroke,
      ),
    );
  }
}

class _IdleButton extends StatelessWidget {
  const _IdleButton({
    required this.cubit,
    required this.state,
    required this.color,
    required this.animationController,
    Key? key,
  }) : super(key: key);

  final BookmarkButtonCubit cubit;
  final BookmarkState state;
  final Color color;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return ExpandTapWidget(
      onTap: () async {
        await HapticFeedback.mediumImpact();
        await animationController.forward();
        await animationController.reverse();
        await cubit.switchState();
      },
      tapPadding: const EdgeInsets.all(AppDimens.m),
      child: state.icon(color),
    );
  }
}

extension on BookmarkState {
  SvgPicture icon(Color color) {
    return map(
      bookmarked: (_) => SvgPicture.asset(
        AppVectorGraphics.bookmarkFilled,
        color: color,
      ),
      notBookmarked: (_) => SvgPicture.asset(
        AppVectorGraphics.bookmarkOutline,
        color: color,
      ),
    );
  }
}
