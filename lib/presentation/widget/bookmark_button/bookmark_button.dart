import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
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

enum BookmarkButtonMode { image, color }

class BookmarkButton extends HookWidget {
  BookmarkButton.article({
    required MediaItemArticle article,
    required BookmarkButtonMode mode,
    String? topicId,
    String? briefId,
    SnackbarController? snackbarController,
    Key? key,
  }) : this._(
          BookmarkTypeData.article(article.slug, article.id, topicId, briefId),
          mode: mode,
          snackbarController: snackbarController,
          key: key,
        );

  BookmarkButton.topic({
    required Topic topic,
    required BookmarkButtonMode mode,
    String? briefId,
    SnackbarController? snackbarController,
    Key? key,
  }) : this._(
          BookmarkTypeData.topic(topic.slug, topic.id, briefId),
          mode: mode,
          snackbarController: snackbarController,
          key: key,
        );

  const BookmarkButton._(
    this._data, {
    required this.mode,
    this.snackbarController,
    Key? key,
  }) : super(key: key);

  final BookmarkTypeData _data;
  final BookmarkButtonMode mode;
  final SnackbarController? snackbarController;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<BookmarkButtonCubit>();
    final state = useCubitBuilder(cubit);
    final _animationController = useAnimationController(
      duration: const Duration(
        milliseconds: _animationDuration,
      ),
    );

    useCubitListener<BookmarkButtonCubit, BookmarkButtonState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          bookmarkAdded: (_) {
            snackbarController?.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.bookmark_bookmarkSuccess),
                type: SnackbarMessageType.positive,
              ),
            );
          },
          bookmarkRemoved: (value) {
            snackbarController?.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.bookmark_unbookmarkSuccess),
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
      [
        cubit,
        _data,
      ],
    );

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.4).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.bounceInOut,
        ),
      ),
      child: SizedBox.square(
        dimension: _iconSize,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.xs),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: _animationDuration),
              child: state.maybeMap(
                initializing: (_) => const SizedBox.square(
                  dimension: _loaderSize,
                  child: Loader(
                    color: AppColors.limeGreen,
                    strokeWidth: _loaderStroke,
                  ),
                ),
                idle: (state) => _IdleButton(
                  cubit: cubit,
                  state: state.state,
                  mode: mode,
                  animationController: _animationController,
                ),
                switching: (state) => const _Switching(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IdleButton extends StatelessWidget {
  const _IdleButton({
    required this.cubit,
    required this.state,
    required this.mode,
    required this.animationController,
    Key? key,
  }) : super(key: key);

  final BookmarkButtonCubit cubit;
  final BookmarkState state;
  final BookmarkButtonMode mode;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await HapticFeedback.mediumImpact();
        await animationController.forward();
        await animationController.reverse();
        await cubit.switchState();
      },
      child: state.icon(mode),
    );
  }
}

class _Switching extends StatelessWidget {
  const _Switching({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AppVectorGraphics.heartInactive);
  }
}

extension on BookmarkState {
  SvgPicture icon(BookmarkButtonMode mode) {
    switch (mode) {
      case BookmarkButtonMode.image:
        return map(
          bookmarked: (_) => SvgPicture.asset(AppVectorGraphics.heartSelectedNoBorder),
          notBookmarked: (_) => SvgPicture.asset(AppVectorGraphics.heartUnselectedWhite),
        );
      case BookmarkButtonMode.color:
        return map(
          bookmarked: (_) => SvgPicture.asset(AppVectorGraphics.heartSelected),
          notBookmarked: (_) => SvgPicture.asset(AppVectorGraphics.heartUnselected),
        );
    }
  }
}
