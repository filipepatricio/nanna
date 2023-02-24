import 'dart:ui';

import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:injectable/injectable.dart';

@injectable
class ColorMapper implements BidirectionalMapper<int, Color> {
  @override
  int from(Color data) => data.value;

  @override
  Color to(int data) => Color(data);
}

@injectable
class OptionalColorMapper implements BidirectionalMapper<int?, Color?> {
  @override
  int? from(Color? data) => data?.value;

  @override
  Color? to(int? data) => data != null ? Color(data) : null;
}
