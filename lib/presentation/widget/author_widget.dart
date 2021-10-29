import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/widgets.dart';

class AuthorRow extends StatelessWidget {
  final Topic topic;

  const AuthorRow({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppRasterGraphics.editorSample),
        const SizedBox(width: AppDimens.s),
        Text(
          'By Editorial Team', // TODO probably will be coming from API
          style: AppTypography.metadata2Bold.copyWith(fontStyle: FontStyle.italic, fontFamily: fontFamilyLora),
        ),
      ],
    );
  }
}
