import 'package:dailycore/features/habit_tracker/presentation/pages/habit_page.dart';
import 'package:flutter/material.dart';

class HabitDashboard extends StatefulWidget {
  const HabitDashboard({super.key});

  @override
  State<HabitDashboard> createState() => _HabitDashboardState();
}

class _HabitDashboardState extends State<HabitDashboard> {
  final List<Widget> screens = [
    HabitPage(),
    Center(child: Text('Challenge')),
    Center(child: Text('Routine')),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed_rounded),
            label: 'Habit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Routine'),
        ],
      ),
    );
  }
}
