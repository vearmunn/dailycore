import 'package:dailycore/features/todo/presentation/pages/main_pages/browse_view.dart';
import 'package:dailycore/features/todo/presentation/pages/main_pages/upcoming_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'today_view.dart';
import '../../cubit/dashboard_cubit/todo_dashboard_cubit.dart';

class TodoDashboardPage extends StatelessWidget {
  const TodoDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [TodayView(), UpcomingView(), BrowseView()];
    return BlocBuilder<TodoDashboardCubit, int>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: screens[state],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            onTap:
                (index) => context.read<TodoDashboardCubit>().changeTab(index),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: 'Today',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Upcoming',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.line_style),
                label: 'Browse',
              ),
            ],
          ),
        );
      },
    );
  }
}
