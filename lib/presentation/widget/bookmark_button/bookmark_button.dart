import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_state.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/padding_tap_widget.dart';
import 'package:better_informed_mobile/presentation/util/snackbar_util.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/informed_animated_switcher.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
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
    Color? color,
    String? topicId,
    String? briefId,
    double? iconSize,
    VoidCallback? onTap,
    Key? key,
  }) : this._(
          BookmarkTypeData.article(article.slug, article.id, topicId, briefId),
          color: color,
          iconSize: iconSize,
          onTap: onTap,
          key: key,
        );

  BookmarkButton.topic({
    required TopicPreview topic,
    Color? color,
    String? briefId,
    double? iconSize,
    VoidCallback? onTap,
    Key? key,
  }) : this._(
          BookmarkTypeData.topic(topic.slug, topic.id, briefId),
          color: color,
          iconSize: iconSize,
          onTap: onTap,
          key: key,
        );

  const BookmarkButton._(
    this._data, {
    this.color,
    this.iconSize,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final BookmarkTypeData _data;
  final Color? color;
  final double? iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<BookmarkButtonCubit>();
    final state = useCubitBuilder(cubit);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: _animationDuration),
    );
    final snackbarController = useSnackbarController();

    useCubitListener<BookmarkButtonCubit, BookmarkButtonState>(
      cubit,
      (cubit, state, context) {
        state.mapOrNull(
          bookmarkAdded: (_) {
            snackbarController.showMessage(
              SnackbarMessage.simple(
                message: tr(LocaleKeys.bookmark_addBookmarkSuccess),
                type: SnackbarMessageType.positive,
              ),
            );
          },
          bookmarkRemoved: (value) {
            snackbarController.showMessage(
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

    final iconColor = color ?? Theme.of(context).iconTheme.color!;

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
            child: InformedAnimatedSwitcher(
              duration: const Duration(milliseconds: _animationDuration),
              child: state.maybeMap(
                initializing: (_) => _Loader(color: iconColor),
                idle: (state) => _IdleButton(
                  cubit: cubit,
                  state: state.state,
                  color: iconColor,
                  animationController: animationController,
                  onTap: onTap,
                ),
                switching: (state) => _Loader(color: iconColor),
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
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _loaderSize,
      child: Loader(
        color: color,
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
    this.onTap,
    Key? key,
  }) : super(key: key);

  final BookmarkButtonCubit cubit;
  final BookmarkState state;
  final Color color;
  final AnimationController animationController;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PaddingTapWidget(
      onTap: () async {
        await HapticFeedback.mediumImpact();
        await animationController.forward();
        await animationController.reverse();
        if (onTap != null) {
          return onTap?.call();
        }
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
