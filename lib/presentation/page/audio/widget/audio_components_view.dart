part of '../audio_page.dart';

class _AudioComponentsView extends StatelessWidget {
  const _AudioComponentsView({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AudioSeekButton.rewind(),
            const SizedBox(width: AppDimens.m),
            AudioControlButton(article: article),
            const SizedBox(width: AppDimens.m),
            AudioSeekButton.fastForward(),
          ],
        )
      ],
    );
  }
}
