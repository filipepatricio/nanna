import 'dart:io';

import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:flutter/material.dart';

ScrollPhysics getPlatformScrollPhysics([ScrollPhysics? parent]) {
  if (Platform.isAndroid) {
    return ClampingScrollPhysics(parent: parent);
  } else if (Platform.isIOS) {
    return BottomBouncingScrollPhysics(parent: parent);
  }

  return ClampingScrollPhysics(parent: parent);
}
