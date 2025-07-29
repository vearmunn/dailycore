import 'package:dailycore/features/expense_tracker/presentation/cubit/expense_category/expense_category_cubit.dart';
import 'package:dailycore/theme/theme_helper.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../localization/locales.dart';
import '../../domain/models/expense_category.dart';
import '../../widgets/expense_list.dart';
import '../cubit/expense_crud/expense_crud_cubit.dart';

class SearchExpensePage extends StatefulWidget {
  const SearchExpensePage({super.key});

  @override
  State<SearchExpensePage> createState() => _SearchExpensePageState();
}

class _SearchExpensePageState extends State<SearchExpensePage> {
  String selectedType = 'All';
  List<ExpenseCategory> selectedCategories = [];
  late TextEditingController searchController;
  bool isButtonEnabled = false;
  late FlutterLocalization _flutterLocalization;

  @override
  void initState() {
    _flutterLocalization = FlutterLocalization.instance;
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        isButtonEnabled = searchController.text.trim().isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ExpenseCrudCubit>().loadExpenses(
              DateTime.now().year,
              DateTime.now().month,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search),
            hintText: AppLocale.enterKeywords.getString(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dailyCorePurple),
            ),
          ),
        ),
        centerTitle: true,
        bottom: _buildSearchFilters(),
      ),
      body: SafeArea(
        child: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
          builder: (context, state) {
            if (state is ExpenseCrudLoading) {
              return Center(child: Text('Loading...'));
            }
            if (state is ExpenseCrudError) {
              return Center(child: Text(state.errMessage));
            }
            if (state is ExpensesSearchSuccess) {
              if (state.expenseList.isEmpty) {
                return Center(child: Text('No data found'));
              }
              return ListView(
                padding: EdgeInsets.symmetric(vertical: 20),
                children: [ExpenseList(expenseList: state.expenseList)],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  PreferredSize _buildSearchFilters() {
    return PreferredSize(
      preferredSize: Size.fromHeight(200),
      child: Column(
        children: [
          _buildTypeDropDown(),
          verticalSpace(16),
          _buildCategoryDropDown(),
          verticalSpace(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedType = 'All';
                        selectedCategories.clear();
                        searchController.clear();
                      });
                    },
                    child: Text('Reset'),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: dailyCorePurple.withAlpha(
                        isButtonEnabled ? 255 : 100,
                      ),
                      foregroundColor: Colors.white,
                    ),

                    onPressed: () {
                      if (isButtonEnabled) {
                        context.read<ExpenseCrudCubit>().searchExpenses(
                          noteKeywords: searchController.text,
                          type: selectedType,
                          categoryIdList:
                              selectedCategories
                                  .map((item) => item.id)
                                  .toList(),
                        );
                      }
                    },
                    child: Text(AppLocale.submit.getString(context)),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(12),
        ],
      ),
    );
  }

  Widget _buildCategoryDropDown() {
    return BlocBuilder<ExpenseCategoryCubit, ExpenseCategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          final categories =
              state.categoryList.where((item) {
                if (selectedType == 'All') {
                  return item.id != 0;
                } else {
                  return item.id != 0 && item.type == selectedType;
                }
              }).toList();
          return SizedBox(
            // color: Colors.red,
            height: 40,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                Center(child: Text(AppLocale.category.getString(context))),
                horizontalSpace(16),
                selectedCategories.isEmpty
                    ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: dailyCorePurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocale.all.getString(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: selectedCategories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: dailyCorePurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedCategories[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              horizontalSpace(10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategories.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                horizontalSpace(selectedCategories.isEmpty ? 12 : 0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return MultiSelectDialog(
                          selectedColor: dailyCorePurple,
                          itemsTextStyle: TextStyle(
                            color: ThemeHelper.secondaryTextColor(context),
                          ),
                          searchHint: AppLocale.search.getString(context),
                          selectedItemsTextStyle: TextStyle(
                            color: ThemeHelper.defaultTextColor(context),
                          ),
                          title: Text(
                            AppLocale.selectCategory.getString(context),
                          ),
                          cancelText: Text(
                            AppLocale.cancel.getString(context),
                            style: TextStyle(color: Colors.grey),
                          ),
                          searchable: true,
                          items: List.generate(categories.length, (index) {
                            return MultiSelectItem(
                              categories[index],
                              categories[index].name,
                            );
                          }),
                          initialValue: selectedCategories,
                          onConfirm: (values) {
                            setState(() {
                              selectedCategories = values;
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dailyCorePurple,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildTypeDropDown() {
    List<String> typeOptions = ['All', 'Expense', 'Income'];
    List<String> typeOptionsID = ['Semua', 'Pengeluaran', 'Pemasukan'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(AppLocale.type.getString(context)),
          horizontalSpace(16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(),
              color: dailyCorePurple,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                padding: EdgeInsets.fromLTRB(16, 0, 12, 0),
                value: selectedType,
                iconEnabledColor: Colors.white,
                items: [
                  for (int i = 0; i < typeOptions.length; i++)
                    DropdownMenuItem(
                      value: typeOptions[i],
                      child: Text(
                        _flutterLocalization.currentLocale!.languageCode == 'en'
                            ? typeOptions[i]
                            : typeOptionsID[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
                selectedItemBuilder:
                    (context) => [
                      for (int i = 0; i < typeOptions.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 14, right: 12),
                          child: Text(
                            _flutterLocalization.currentLocale!.languageCode ==
                                    'en'
                                ? typeOptions[i]
                                : typeOptionsID[i],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                onChanged: (v) {
                  setState(() {
                    selectedType = v!;
                    selectedCategories.clear();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
