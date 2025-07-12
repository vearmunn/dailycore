import 'package:flutter/material.dart';

import '../expense_tracker/presentation/pages/dashboard.dart';
import '../habit_tracker/presentation/pages/dashboard.dart';
import '../todo/presentation/pages/main_pages/todo_dashboard_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DailyCore')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoDashboardPage()),
                );
              },
              child: Text('ToDo'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitDashboard()),
                );
              },
              child: Text('Habit Tracker'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseDashboard()),
                );
              },
              child: Text('Finance Tracker'),
            ),
          ],
        ),
      ),
    );
  }
}
