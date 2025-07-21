import 'dart:io';

import 'package:dailycore/features/expense_tracker/domain/models/goal.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/goal_add_edit_page.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/goal_detail.dart';
import 'package:dailycore/features/expense_tracker/utils/expense_util.dart';
import 'package:dailycore/utils/dates_utils.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/colors_and_icons.dart';
import '../cubit/goal/goal_cubit.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Goals'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              labelColor: dailyCoreOrange,
              indicatorColor: dailyCoreOrange,
              tabs: [Tab(text: 'Ongoing'), Tab(text: 'Finished')],
            ),
          ),
        ),
        body: BlocBuilder<GoalCubit, GoalState>(
          builder: (context, state) {
            if (state is GoalError) {
              return Center(child: Text(state.errMessage));
            }
            if (state is GoalLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GoalsLoaded) {
              final finishedGoals =
                  state.goalList
                      .where((goal) => goal.currentAmount >= goal.targetAmount)
                      .toList();
              final onGoingGoals =
                  state.goalList
                      .where((goal) => goal.currentAmount < goal.targetAmount)
                      .toList();
              return TabBarView(
                children: [
                  _buildOngoingTab(onGoingGoals),
                  _buildFinishedTab(finishedGoals),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: dailyCoreOrange,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoalAddEditPage()),
              ),
        ),
      ),
    );
  }

  ListView _buildFinishedTab(List<Goal> finishedGoals) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: finishedGoals.length,
      itemBuilder: (BuildContext context, int index) {
        final goal = finishedGoals[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalDetail()),
            );
            context.read<GoalCubit>().loadSingleGoal(goal.id);
          },
          child: Stack(children: [_buildGoalItem(goal), _buildDeadline(goal)]),
        );
      },
    );
  }

  ListView _buildOngoingTab(List<Goal> onGoingGoals) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: onGoingGoals.length,
      itemBuilder: (BuildContext context, int index) {
        final goal = onGoingGoals[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalDetail()),
            );
            context.read<GoalCubit>().loadSingleGoal(goal.id);
          },
          child: Stack(children: [_buildGoalItem(goal), _buildDeadline(goal)]),
        );
      },
    );
  }

  Widget _buildGoalItem(Goal goal) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          goal.imagePath.isEmpty
              ? SizedBox.shrink()
              : ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.file(File(goal.imagePath)),
              ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                verticalSpace(8),
                Row(
                  children: [
                    Text(
                      formatAmountRP(goal.currentAmount),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    horizontalSpace(4),
                    Text(
                      '/ ${formatAmountRP(goal.targetAmount, useSymbol: false)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                verticalSpace(6),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        color: dailyCoreOrange,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(20),
                        value: goal.currentAmount / goal.targetAmount,
                      ),
                    ),
                    horizontalSpace(10),
                    Text(
                      '${getPercentage(goal.currentAmount, goal.targetAmount).toStringAsFixed(0)}%',
                      style: TextStyle(color: dailyCoreOrange),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadline(Goal goal) {
    if (goal.deadline == null) {
      return SizedBox.shrink();
    } else {
      return Positioned(
        top: 16,
        left: 16,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: dailyCoreOrange,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_month, color: Colors.white, size: 20),
              horizontalSpace(8),
              Text(
                goal.deadline!.difference(DateTime.now()).inDays < 30
                    ? 'Days left: ${goal.deadline!.difference(DateTime.now()).inDays}'
                    : formattedDate(goal.deadline!),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }
}
