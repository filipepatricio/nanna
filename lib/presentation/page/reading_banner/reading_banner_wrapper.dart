import 'package:better_informed_mobile/presentation/page/reading_banner/reading_banner_view.dart';
import 'package:flutter/widgets.dart';

class ReadingBannerWrapper extends StatelessWidget {
  const ReadingBannerWrapper({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        ReadingBannerView(),
      ],
    );
  }
}
