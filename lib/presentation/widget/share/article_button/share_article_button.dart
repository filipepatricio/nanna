import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareArticleButton extends HookWidget {
  final MediaItemArticle article;

  const ShareArticleButton({
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareArticleButtonCubit>();
    final state = useCubitBuilder(cubit, buildWhen: (state) => true);

    switch (state) {
      case ShareArticleButtonState.idle:
        return ShareButton(
          onTap: () => cubit.share(
            article,
          ),
        );
      case ShareArticleButtonState.processing:
        return const Loader();
    }
  }
}
