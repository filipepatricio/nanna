import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/audio/cubit/audio_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article/article_dotted_info.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/progress_bar/audio_progress_bar.dart';
import 'package:better_informed_mobile/presentation/widget/audio/seek_button/audio_seek_button.dart';
import 'package:better_informed_mobile/presentation/widget/audio/speed_button/audio_speed_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/image_top_gradient.dart';
import 'package:better_informed_mobile/presentation/widget/informed_close_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'widget/audio_components_view.dart';
part 'widget/audio_page_app_bar.dart';
part 'widget/audio_page_body.dart';

class AudioPage extends HookWidget {
  const AudioPage({
    required this.article,
    required this.audioFile,
    super.key,
  });

  final MediaItemArticle article;
  final AudioFile audioFile;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<AudioPageCubit>();
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

    return SnackbarParentView(
      child: Scaffold(
        body: Stack(
          children: [
            _AudioPageBody(
              article: article,
              audioFile: audioFile,
            ),
            if (article.hasImage)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ImageTopGradient(),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _AudioPageAppBar(
                article: article,
                isLight: article.hasImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
