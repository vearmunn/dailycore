import 'package:dailycore/features/todo/presentation/pages/browse_view.dart';
import 'package:dailycore/features/todo/presentation/pages/upcoming_view.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import 'today_view.dart';
import '../cubit/dashboard_cubit/todo_dashboard_cubit.dart';

class TodoDashboardPage extends StatelessWidget {
  const TodoDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [TodayView(), UpcomingView(), BrowseView()];
    return BlocBuilder<TodoDashboardCubit, int>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              AppLocale.todoTitle.getString(context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: dailyCoreBlue,
          ),
          body: screens[state],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: dailyCoreBlue,
            currentIndex: state,
            onTap:
                (index) => context.read<TodoDashboardCubit>().changeTab(index),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_rounded),
                label: AppLocale.today.getString(context),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: AppLocale.upcoming.getString(context),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.line_style),
                label: AppLocale.browse.getString(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
