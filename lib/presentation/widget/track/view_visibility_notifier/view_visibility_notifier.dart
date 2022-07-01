import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ViewVisibilityNotifier extends HookWidget {
  const ViewVisibilityNotifier({
    required this.detectorKey,
    required this.borderFraction,
    required this.onVisible,
    required this.child,
    Key? key,
  }) : super(key: key);
  final Key detectorKey;
  final double borderFraction;
  final VoidCallback onVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final visible = useState(false);
    final isMounted = useIsMounted();

    useEffect(
      () {
        if (visible.value) {
          onVisible();
        }
      },
      [visible.value],
    );

    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: !kIsTest
          ? (visibility) {
              if (isMounted()) {
                visible.value = visibility.visibleFraction >= borderFraction;
              }
            }
          : null,
      child: child,
    );
  }
}
