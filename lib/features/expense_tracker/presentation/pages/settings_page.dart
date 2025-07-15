import 'package:flutter/material.dart';

import 'expense_category_page.dart';
import 'goal_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finance Tracker',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseCategoryPage(),
                  ),
                );
              },
              child: Text('Adjust Category'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalPage()),
                );
              },
              child: Text('Goals'),
            ),
          ],
        ),
      ),
    );
  }
}
