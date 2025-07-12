import 'package:dailycore/features/todo/data/models/hive_todo.dart';
import 'package:dailycore/features/todo/presentation/pages/filter_todos_view.dart';
import 'package:dailycore/features/todo/presentation/pages/todo_category_view.dart';
import 'package:dailycore/hive_boxes/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../utils/todo_utils.dart';

class BrowseView extends StatefulWidget {
  const BrowseView({super.key});

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TodoHive>(todoBox);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextButton(
            onPressed: () {
              box.clear();
            },
            child: Text('Delete All Todos'),
          ),
          Text(
            'Browse Todos',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterTodosView()),
                ),
            child: Text('Search Todos'),
          ),
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoCategoryView()),
                ),
            child: Text('Category'),
          ),
          TextButton(onPressed: () {}, child: Text('Completed')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoBox(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
