import 'package:dailycore/features/todo/presentation/pages/completed_todos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../localization/locales.dart';
import '../../utils/todo_utils.dart';
import 'filter_todos_view.dart';
import 'todo_category_view.dart';

class BrowseView extends StatefulWidget {
  const BrowseView({super.key});

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  @override
  Widget build(BuildContext context) {
    // final box = Hive.box<TodoHive>(todoBox);
    return Scaffold(
      body: ListView(
        // padding: EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocale.browseTodos.getString(context),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(
              AppLocale.searchTodos.getString(context),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterTodosView()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text(
              AppLocale.adjustCategories.getString(context),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoCategoryView()),
                ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text(
              AppLocale.completedTodos.getString(context),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedTodosPage()),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoBox(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
