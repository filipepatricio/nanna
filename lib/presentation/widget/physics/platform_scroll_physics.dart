import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:better_informed_mobile/presentation/widget/physics/bottom_bouncing_physics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ScrollPhysics getPlatformScrollPhysics([ScrollPhysics? parent]) {
  if (defaultTargetPlatform.isAndroid) {
    return ClampingScrollPhysics(parent: parent);
  }

  if (defaultTargetPlatform.isApple) {
    return BottomBouncingScrollPhysics(parent: parent);
  }

  return ClampingScrollPhysics(parent: parent);
}
