part of 'article_cover.dart';

class _ArticleOpacity extends StatelessWidget {
  const _ArticleOpacity({
    required this.article,
    required this.child,
    this.available = true,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final bool available;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: article.finished || !available ? AppDimens.unavailableItemOpacity : 1,
      child: child,
    );
  }
}
