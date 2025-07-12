import 'package:dailycore/features/expense_tracker/presentation/pages/expense_category_page.dart';
import 'package:flutter/material.dart';

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
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseCategoryPage()),
            );
          },
          child: Text('Adjust Category'),
        ),
      ),
    );
  }
}
