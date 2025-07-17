import 'package:flutter/material.dart';

import '../../../../utils/colors_and_icons.dart';
import 'expense_category_page.dart';
import 'goal_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dailyCoreBlue,
        title: Text(
          'Finance',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
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
