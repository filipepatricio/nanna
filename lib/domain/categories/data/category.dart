class Category {
  const Category({
    required this.name,
    required this.id,
    required this.slug,
    required this.svgIcon,
  });

  final String svgIcon;
  final String id;
  final String name;
  final String slug;
}
