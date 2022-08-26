import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/view_all_button.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/horizontal_list_interaction_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef ExploreAreaItemBuilder<T> = Widget Function(T itemValue, int index);

class ExploreAreaItemCarouselView<T> extends HookWidget {
  const ExploreAreaItemCarouselView({
    required this.itemBuilder,
    required this.items,
    required this.itemWidth,
    this.areaId,
    this.onViewAllTap,
    double? itemHeight,
    Key? key,
  })  : itemHeight = itemHeight ?? itemWidth,
        super(key: key);

  final String? areaId;
  final ExploreAreaItemBuilder<T> itemBuilder;
  final List<ExploreAreaItem<T>> items;
  final double itemWidth;
  final double itemHeight;
  final VoidCallback? onViewAllTap;

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();

    return SizedBox(
      height: itemHeight,
      child: GeneralEventTracker(
        controller: eventController,
        child: HorizontalListInteractionListener(
          callback: (lastVisibleItemIndex) {
            final areaId = this.areaId;
            if (areaId != null) {
              eventController.track(
                AnalyticsEvent.exploreAreaCarouselBrowsed(
                  areaId,
                  lastVisibleItemIndex,
                ),
              );
            }
          },
          itemsCount: items.length,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            itemBuilder: (context, index) {
              return _Cell(
                itemBuilder: itemBuilder,
                item: items[index],
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                index: index,
                onViewAllTap: onViewAllTap,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: AppDimens.m,
              );
            },
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}

class _Cell<T> extends StatelessWidget {
  const _Cell({
    required this.itemBuilder,
    required this.item,
    required this.itemWidth,
    required this.itemHeight,
    required this.index,
    this.onViewAllTap,
    Key? key,
  }) : super(key: key);

  final ExploreAreaItemBuilder<T> itemBuilder;
  final ExploreAreaItem<T> item;
  final double itemWidth;
  final double itemHeight;
  final int index;
  final VoidCallback? onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return item.map(
      standard: (item) => SizedBox(
        height: itemHeight,
        width: itemWidth,
        child: itemBuilder(
          item.value,
          index,
        ),
      ),
      viewAll: (item) => Align(
        alignment: Alignment.topCenter,
        child: SizedBox.square(
          dimension: itemWidth,
          child: ViewAllButton(
            title: item.title,
            onTap: onViewAllTap,
          ),
        ),
      ),
    );
  }
}
