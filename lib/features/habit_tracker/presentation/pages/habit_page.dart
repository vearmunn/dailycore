import 'package:dailycore/features/habit_tracker/domain/models/habit.dart';
import 'package:dailycore/features/habit_tracker/presentation/pages/add_edit_habit_page.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/features/habit_tracker/widgets/table_calendart.dart';
import 'package:dailycore/features/habit_tracker/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../components/color_icon_selector/color_icon_selector_cubit.dart';
import '../../../../localization/locales.dart';
import '../../../../utils/spaces.dart';
import '../../widgets/habit_tile.dart';
import '../crud_cubit/habit_crud_cubit.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  bool showTodaysHabits = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dailyCoreGreen,
        title: Text(
          AppLocale.habitTitle.getString(context),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      // backgroundColor: Colors.grey.shade200,
      body: _buildHabitList(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: dailyCoreGreen,
        onPressed: () {
          context.read<ColorSelectorCubit>().setColor(
            colorSelections[randomIndex(colorSelections.length)],
          );
          context.read<IconSelectorCubit>().setIcon(getRandomIcon());
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
                        color: dailyCoreGreen,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.sort, color: Colors.white),
                          horizontalSpace(6),
                          Text(
                            showTodaysHabits
                                ? AppLocale.todaysHabit.getString(context)
                                : AppLocale.allHabit.getString(context),
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
                padding: EdgeInsets.all(16),
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
                  return buildHabitTile(
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
}
