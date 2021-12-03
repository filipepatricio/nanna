import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button_cubit.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShareArticleButton extends HookWidget {
  final MediaItemArticle article;
  final WidgetBuilder? buttonBuilder;

  const ShareArticleButton({
    required this.article,
    this.buttonBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ShareArticleButtonCubit>();
    final state = useCubitBuilder(cubit, buildWhen: (state) => true);

    final builder = buttonBuilder;

    switch (state) {
      case ShareArticleButtonState.idle:
        if (builder == null) {
          return ShareButton(
            onTap: () => cubit.share(article),
          );
        } else {
          return GestureDetector(
            onTap: () => cubit.share(article),
            child: builder(context),
          );
        }
      case ShareArticleButtonState.processing:
        return const Loader();
    }
  }
}
