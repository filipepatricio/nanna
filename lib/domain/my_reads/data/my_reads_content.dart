import 'package:better_informed_mobile/domain/my_reads/data/my_reads_item.dart';

class MyReadsContent {
  final int itemsCount;
  final List<MyReadsItem> items;

  MyReadsContent({
    required this.itemsCount,
    required this.items,
  });
}
