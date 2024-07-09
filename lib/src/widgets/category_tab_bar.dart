import 'package:flutter/material.dart';
import 'package:task/core/model/product_model.dart';
import 'package:task/src/screens/home/ctrl_home.dart';

class CategoryTabBar extends StatelessWidget {
  final List<CategoryModel> categories;
  final HomeController controller;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      isScrollable: true,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      tabs: categories.map((category) {
        return Tab(text: category.name);
      }).toList(),
      onTap: (index) {
        int categoryId = categories[index].id;
        controller.selectedCategoryId.value = categoryId;
        controller.pageIndex.value = 1; // Reset page index
        controller.fetchSubcategories(categoryId, 1);
      },
    );
  }
}
