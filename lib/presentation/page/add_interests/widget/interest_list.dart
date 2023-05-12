part of '../add_interests_page.dart';

class _InterestList extends StatelessWidget {
  const _InterestList({
    required this.categories,
    required this.selectedCategories,
    required this.onSelected,
    required this.onUnselected,
  });

  final List<Category> categories;
  final Set<Category> selectedCategories;
  final Function(Category category) onSelected;
  final Function(Category category) onUnselected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final category in categories) ...[
          InterestListItem(
            category: category,
            isSelected: selectedCategories.contains(category),
            onTap: () {
              if (selectedCategories.contains(category)) {
                onUnselected(category);
              } else {
                onSelected(category);
              }
            },
          ),
          const SizedBox(height: AppDimens.s),
        ],
      ],
    );
  }
}
