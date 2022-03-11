import 'package:better_informed_mobile/presentation/widget/informed_selectable_text.dart';
import 'package:flutter/material.dart';

class SelectionControllerBundle {
  SelectionControllerBundle() : _selectionControllers = {};

  final Set<TextSpanEditingController> _selectionControllers;

  void add(TextSpanEditingController controller) => _selectionControllers.add(controller);

  void unselectAllBut(Key key) {
    for (final controller in _selectionControllers) {
      if (controller.key != key && !controller.selection.isCollapsed) {
        controller.selection = const TextSelection.collapsed(offset: 0);
      }
    }
  }

  void clear() => _selectionControllers.clear();
}
