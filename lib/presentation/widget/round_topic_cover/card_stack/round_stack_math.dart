import 'dart:math';
import 'dart:ui';

double calculateCornersHeightDifference({
  required Offset leftCorner,
  required Offset rightCorner,
  required Offset origin,
  required double angle,
}) {
  const angleInRadians = -5 * pi * 180;

  final rotatedLeftTopY = origin.dy + (leftCorner.dx * sin(angleInRadians) - leftCorner.dy * cos(angleInRadians));
  final rotatedRightTopY = origin.dy + (rightCorner.dx * sin(angleInRadians) - rightCorner.dy * cos(angleInRadians));

  return (rotatedLeftTopY - rotatedRightTopY).abs();
}
