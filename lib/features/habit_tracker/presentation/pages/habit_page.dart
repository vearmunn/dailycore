import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/presentation/pages/add_edit_habit_page.dart';
import 'package:dailycore/features/habit_tracker/presentation/pages/habit_detail_page.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/features/habit_tracker/widgets/table_calendart.dart';
import 'package:dailycore/features/habit_tracker/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../components/color_selector/color_icon_selector_cubit.dart';
import '../../../../utils/spaces.dart';
import '../crud_cubit/habit_crud_cubit.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  bool showTodaysHabits = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _buildHabitList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ColorSelectorCubit>().setColor(
            colorSelections[randomIndex(colorSelections.length)],
          );
          context.read<IconSelectorCubit>().setIcon(
            iconSelections[randomIndex(iconSelections.length)],
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddEditHabitPage(habit: Habit(id: 0, name: '')),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitList(BuildContext context) {
    final habitCubit = context.read<HabitCrudCubit>();
    return BlocBuilder<HabitCrudCubit, HabitCrudState>(
      builder: (context, state) {
        if (state is HabitCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is HabitCrudError) {
          return Center(child: Text(state.errMessage));
        }
        if (state is HabitCrudLoaded) {
          final todaysHabits = habitsDueToday(state.habits);
          return ListView(
            children: [
              HabitTableCalendar(
                dailyProgress: prepCalendarDataset(state.habits),
              ),
              verticalSpace(20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showTodaysHabits = !showTodaysHabits;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: dailyCoreBlue,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.sort, color: Colors.white),
                          horizontalSpace(6),
                          Text(
                            showTodaysHabits ? "Today's Habits" : "All Habits",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    showTodaysHabits
                        ? todaysHabits.length
                        : state.habits.length,
                itemBuilder: (BuildContext context, int index) {
                  final habit =
                      showTodaysHabits
                          ? todaysHabits[index]
                          : state.habits[index];
                  bool isCompletedToday = isHabitCompletedToday(
                    habit.completedDays!,
                  );
                  return _buildHabitTile(
                    context: context,
                    habit: habit,
                    habitCubit: habitCubit,
                    isCompletedToday: isCompletedToday,
                  );
                },
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildHabitTile({
    required BuildContext context,
    required Habit habit,
    required bool isCompletedToday,
    required HabitCrudCubit habitCubit,
  }) {
    int currentStreak = 0;

    if (habit.repeatType == 'daily') {
      currentStreak = getDailyStreaks(habit.completedDays)[0];
    } else if (habit.repeatType == 'weekly') {
      currentStreak =
          getWeeklyStreaks(
            dates: habit.completedDays,
            selectedDays: habit.daysofWeek,
          )[0];
    } else {
      currentStreak =
          getMonthlyStreak(
            dates: habit.completedDays,
            selectedDates: habit.datesofMonth,
          )[0];
    }

    return GestureDetector(
      onTap: () {
        habitCubit.loadSingleHabit(habit.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HabitDetailPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: fromArgb32(habit.color).withAlpha(30),
              ),
              child: Icon(
                color: fromArgb32(habit.color),
                IconData(
                  habit.icon['code_point'],
                  fontFamily: habit.icon['font_family'],
                ),
              ),
            ),
            horizontalSpace(16),
            Expanded(child: Text(habit.name)),
            horizontalSpace(currentStreak == 0 ? 0 : 20),
            currentStreak == 0
                ? SizedBox.shrink()
                : Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        'assets/images/danger.png',
                        width: 28,
                        color: Colors.orange,
                      ),
                      Text(
                        currentStreak.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            horizontalSpace(12),
            Checkbox(
              shape: CircleBorder(),
              visualDensity: VisualDensity.compact,
              value: isCompletedToday,
              activeColor: fromArgb32(habit.color),
              onChanged: (_) => habitCubit.toggleHabit(habit),
              // onChanged: (v) => habitCubit.toggleHabit(habit),
            ),
          ],
        ),
      ),
    );
  }
}
