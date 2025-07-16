import 'package:dailycore/features/todo/presentation/pages/completed_todos_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../../../../hive_boxes/boxes.dart';
import '../../data/models/hive_todo.dart';
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
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedTodosPage()),
                ),
            child: Text('Completed'),
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
