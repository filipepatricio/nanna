import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_audio_view_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef AudioCubitBuilder = Widget Function(PremiumArticleAudioViewCubit cubit);

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
    final imageUrl = useArticleImageUrl(
      article,
      AppDimens.articleAudioCoverSize,
      AppDimens.articleAudioCoverSize,
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
