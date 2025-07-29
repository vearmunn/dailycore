// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';

import '../../../utils/spaces.dart';
import '../domain/models/expense_category.dart';

class CategoryGrid extends StatelessWidget {
  final List<ExpenseCategory> categoryList;
  final ValueChanged<ExpenseCategory> onTap;
  final List<ExpenseCategory> selectedCategories;
  const CategoryGrid({
    super.key,
    required this.categoryList,
    required this.onTap,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCategoryIdList =
        selectedCategories.map((item) => item.id).toList();
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 9 / 12,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),

      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final category = categoryList[index];
        return GestureDetector(
          onTap: () => onTap(category),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      !selectedCategoryIdList.contains(category.id)
                          ? ThemeHelper.isDark(context)
                              ? Colors.grey.shade900
                              : Colors.grey.shade300
                          : category.color,
                ),
                child: Icon(
                  getIconByName(category.iconName),
                  size: 30,
                  color:
                      !selectedCategoryIdList.contains(category.id)
                          ? Colors.grey.shade500
                          : Colors.white,
                ),
              ),

              verticalSpace(6),
              Text(category.name, style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
