import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view_cubit.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef AudioCubitBuilder = Widget Function(PremiumArticleAudioViewCubit cubit);

const _audioCoverSize = 1024;

class PremiumArticleAudioCubitProvider extends HookWidget {
  const PremiumArticleAudioCubitProvider({
    required this.article,
    required this.audioCubitBuilder,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final AudioCubitBuilder audioCubitBuilder;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<PremiumArticleAudioViewCubit>();
    final cloudinaryProvider = useCloudinaryProvider();
    final imageUrl = useMemoized(
      () {
        final optionalId = article.image?.publicId;
        if (optionalId != null) {
          return cloudinaryProvider
              .withPublicIdAsPng(optionalId)
              .transform()
              .autoGravity()
              .width(_audioCoverSize)
              .height(_audioCoverSize)
              .generateNotNull();
        }
      },
      [article],
    );

    useEffect(
      () {
        cubit.initialize(article, imageUrl);
      },
      [cubit, article],
    );

    return audioCubitBuilder(cubit);
  }
}
