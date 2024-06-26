import 'package:better_informed_mobile/presentation/util/code_unit_util.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension StringComparisionExtenion on String {
  bool get endsWithWhiteSpace => isNotEmpty && CodeUnitUtil.isWhitespace(codeUnitAt(length - 1));
}
