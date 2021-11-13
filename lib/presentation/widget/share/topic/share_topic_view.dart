import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/custom_rich_text.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class ShareTopicView extends HookWidget implements BaseShareCompletable {
  final Topic topic;
  final List<MediaItemArticle> articles;
  final Completer _baseViewCompleter;

  ShareTopicView({
    required this.topic,
    required this.articles,
    Key? key,
  })  : _baseViewCompleter = Completer(),
        super(key: key);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final imageUrl = useMemoized(
      () => cloudinary.withPublicId(topic.coverImage.publicId).transform().width(2160).fit().generateNotNull(),
    );
    final image = useMemoized(
      () => Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );

    useEffect(
      () {
        final stream = image.image.resolve(ImageConfiguration.empty);
        final imageStreamListener = ImageStreamListener(
          (info, syncCall) => _baseViewCompleter.complete(),
          onError: (info, syncCall) => _baseViewCompleter.completeError(info),
        );
        stream.addListener(imageStreamListener);
        return () => stream.removeListener(imageStreamListener);
      },
      [image],
    );

    return Material(
      color: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Stack(
              children: [
                image,
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 80,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimens.m),
                    color: AppColors.background,
                    child: CustomRichText(
                      textSpan: TextSpan(
                        text: topic.title,
                        style: AppTypography.h3Bold.copyWith(fontSize: 30),
                      ),
                      highlightColor: AppColors.limeGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
              child: Column(
                children: [
                  Text('Includes both global warming driven by human-induced emissions.'),
                  const SizedBox(height: AppDimens.m),
                  Row(
                    children: [],
                  ),
                  const SizedBox(height: AppDimens.xl),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(AppVectorGraphics.informedLogoDark),
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
