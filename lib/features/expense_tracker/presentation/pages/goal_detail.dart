import 'dart:io';

import 'package:dailycore/features/expense_tracker/presentation/pages/goal_add_edit_page.dart';
import 'package:dailycore/features/expense_tracker/presentation/pages/goal_deposit_history_page.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:dailycore/utils/delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../components/custom_textfield.dart';
import '../../../../components/numpad/numpad.dart';
import '../../../../components/numpad/numpad_cubit.dart';
import '../../../../localization/locales.dart';
import '../../../../utils/colors_and_icons.dart';
import '../../../../utils/dates_utils.dart';
import '../../../../utils/spaces.dart';
import '../../domain/models/goal.dart';
import '../../utils/expense_util.dart';
import '../cubit/goal/goal_cubit.dart';

class GoalDetail extends StatefulWidget {
  const GoalDetail({super.key});

  @override
  State<GoalDetail> createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  late TextEditingController noteController;

  @override
  void initState() {
    noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: BlocBuilder<GoalCubit, GoalState>(
        builder: (context, state) {
          if (state is SingleGoalLoaded) {
            final goal = state.goal;
            return Stack(
              children: [
                _buildGoalDetails(goal),
                _buildCustomAppBar(context, goal),
              ],
            );
          }
          if (state is GoalError) {
            return Center(child: Text(state.errMessage));
          }
          if (state is GoalLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox.shrink();
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  DateTime(2025, 10, 10);
                  _buildAmountModalSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dailyCoreBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: Text(AppLocale.addDeposit.getString(context)),
              ),
            ),
            horizontalSpace(12),
            BlocBuilder<GoalCubit, GoalState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    if (state is SingleGoalLoaded) {
                      final result = await showDeleteBox(
                        context,
                        AppLocale.deleteThisGoal.getString(context),
                      );
                      if (result == true) {
                        context.read<GoalCubit>().deleteGoal(state.goal.id);
                        Navigator.pop(context);
                        successToast(
                          context,
                          AppLocale.goalDeleted.getString(context),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Icon(Icons.delete),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildAmountModalSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, //
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.3,
            ),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: BlocBuilder<NumpadCubit, String>(
                  builder: (context, input) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocale.addDeposit.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        customTextfield(
                          AppLocale.note.getString(context),
                          noteController,
                        ),

                        verticalSpace(20),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Text(
                            input.isEmpty
                                ? '0'
                                : formatAmountRP(double.parse(input)),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        verticalSpace(12),
                        NumberPad(),
                        verticalSpace(16),
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<GoalCubit, GoalState>(
                            builder: (context, state) {
                              if (state is SingleGoalLoaded) {
                                return ElevatedButton(
                                  onPressed: () {
                                    context.read<GoalCubit>().addAmount(
                                      id: state.goal.id,
                                      amount: double.parse(input),
                                      note: noteController.text,
                                    );
                                    Navigator.pop(context);
                                    context.read<NumpadCubit>().clear();
                                    noteController.clear();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: dailyCoreBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Text(AppLocale.add.getString(context)),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildGoalDetails(Goal goal) {
    return ListView(
      children: [
        Image.file((File(goal.imagePath))),
        verticalSpace(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (goal.deadline != null)
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: dailyCoreBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 20,
                          ),
                          horizontalSpace(8),
                          Text(
                            goal.deadline!.difference(DateTime.now()).inDays <
                                    30
                                ? '${AppLocale.daysLeft.getString(context)} ${goal.deadline!.difference(DateTime.now()).inDays}'
                                : formattedDate(goal.deadline!),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              verticalSpace(12),
              Text(
                goal.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              verticalSpace(10),
              if (goal.description != null)
                Text(
                  goal.description!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
              verticalSpace(16),
              Row(
                children: [
                  Text(
                    formatAmountRP(goal.currentAmount),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  horizontalSpace(4),
                  Text(
                    '/ ${formatAmountRP(goal.targetAmount, useSymbol: false)}',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    '${getPercentage(goal.currentAmount, goal.targetAmount).toStringAsFixed(0)}%',
                  ),
                ],
              ),
              verticalSpace(10),
              LinearProgressIndicator(
                color: dailyCoreBlue,
                minHeight: 10,
                borderRadius: BorderRadius.circular(20),
                value: goal.currentAmount / goal.targetAmount,
              ),
              verticalSpace(30),
            ],
          ),
        ),
      ],
    );
  }

  SafeArea _buildCustomAppBar(BuildContext context, Goal goal) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIconButton(
              context,
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);
                context.read<GoalCubit>().loadGoals();
              },
            ),
            Spacer(),
            _buildIconButton(
              context,
              icon: Icons.edit,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            GoalAddEditPage(goal: goal, isUpdating: true),
                  ),
                );
              },
            ),
            horizontalSpace(16),
            _buildIconButton(
              context,
              icon: Icons.receipt_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GoalDepositHistoryPage(
                          depositHistoryList: goal.depositHistoryList ?? [],
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(icon),
      ),
    );
  }
}
