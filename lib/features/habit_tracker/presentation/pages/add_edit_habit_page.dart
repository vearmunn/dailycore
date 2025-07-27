// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/components/color_selector/color_icon_selector_cubit.dart';
import 'package:dailycore/components/color_selector/color_selector_widget.dart';
import 'package:dailycore/components/color_selector/icon_selector_widget.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:dailycore/utils/delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/habit_tracker/presentation/crud_cubit/habit_crud_cubit.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../../components/color_selector/icon_color_selected_widget.dart';
import '../../../../components/custom_textfield.dart';
import '../../../../utils/spaces.dart';
import '../../domain/models/habit.dart';

class AddEditHabitPage extends StatefulWidget {
  const AddEditHabitPage({
    super.key,
    this.isUpadting = false,
    required this.habit,
  });
  final bool isUpadting;
  final Habit habit;

  @override
  State<AddEditHabitPage> createState() => _AddEditHabitPageState();
}

class _AddEditHabitPageState extends State<AddEditHabitPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String _selectedFrequency = 'daily';
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<int> selectedDays = [];
  List<int> dates = List.generate(31, (index) => index + 1);
  List<int> selectedDates = [];
  bool showColorSelections = false;
  bool showIconSelections = false;
  bool shouldAddtoExpense = false;
  int hourTimeReminder = 9;
  int minuteTimeReminder = 0;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUpadting) {
      hourTimeReminder = widget.habit.hourTimeReminder;
      minuteTimeReminder = widget.habit.minuteTimeReminder;
      nameController.text = widget.habit.name;
      descriptionController.text = widget.habit.description;
      _selectedFrequency = widget.habit.repeatType;
      selectedDates.addAll(widget.habit.datesofMonth);
      selectedDays.addAll(widget.habit.daysofWeek);
      shouldAddtoExpense = widget.habit.shouldAddToExpense;
      context.read<ColorSelectorCubit>().setColor(
        fromArgb32(widget.habit.color),
      );
      context.read<IconSelectorCubit>().setIcon(
        getIconByName(widget.habit.iconName),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpadting ? 'Edit Habit' : 'Add Habit'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          customTextfield('Name', nameController),
          verticalSpace(16),
          customTextfield('Description (Optional)', descriptionController),
          verticalSpace(16),
          Row(
            children: [
              colorOrIconSelected(true, () {
                setState(() {
                  showColorSelections = !showColorSelections;
                  showIconSelections = false;
                });
              }),
              horizontalSpace(16),
              colorOrIconSelected(false, () {
                setState(() {
                  showIconSelections = !showIconSelections;
                  showColorSelections = false;
                });
              }),
            ],
          ),
          verticalSpace(16),

          colorSelector(showColorSelections),

          iconSelector(showIconSelections),

          if (showColorSelections || showIconSelections) verticalSpace(16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Text(
                    'Frequency',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                _buildFrequencyOption(title: 'Everyday', repeatType: 'daily'),
                _buildFrequencyOption(
                  title: 'Specific days of the week',
                  repeatType: 'weekly',
                ),
                _buildFrequencyOption(
                  title: 'Specific dates of the month',
                  repeatType: 'monthly',
                ),
                verticalSpace(16),
              ],
            ),
          ),
          verticalSpace(16),
          GestureDetector(
            onTap: () async {
              final DateTime? time = await showOmniDateTimePicker(
                context: context,
                type: OmniDateTimePickerType.time,
                initialDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  hourTimeReminder,
                  minuteTimeReminder,
                ),

                is24HourMode: true,
                isShowSeconds: false,
              );
              setState(() {
                hourTimeReminder = time == null ? hourTimeReminder : time.hour;
                minuteTimeReminder =
                    time == null ? minuteTimeReminder : time.minute;
              });
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'When should we remind you?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  verticalSpace(12),
                  Center(
                    child: BlocBuilder<ColorSelectorCubit, Color>(
                      builder: (context, selectedColor) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${hourTimeReminder < 10 ? '0$hourTimeReminder' : hourTimeReminder} : ${minuteTimeReminder < 10 ? '0$minuteTimeReminder' : minuteTimeReminder}',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: selectedColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          verticalSpace(16),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                BlocBuilder<ColorSelectorCubit, Color>(
                  builder: (context, selectedColor) {
                    return Checkbox(
                      activeColor: selectedColor,
                      value: shouldAddtoExpense,
                      shape: CircleBorder(),
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) {
                        setState(() {
                          shouldAddtoExpense = !shouldAddtoExpense;
                        });
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    ' Add to Finance Tracker when habit is checked?',
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(100),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<ColorSelectorCubit, Color>(
                builder: (context, selectedColor) {
                  return BlocBuilder<IconSelectorCubit, IconData>(
                    builder: (context, selectedIcon) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: dailyCoreBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            errorToast(context, 'Name must not be empty!');
                          } else {
                            if (widget.isUpadting) {
                              context.read<HabitCrudCubit>().updateHabit(
                                Habit(
                                  id: widget.habit.id,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  repeatType: _selectedFrequency,
                                  datesofMonth: selectedDates,
                                  daysofWeek: selectedDays,
                                  color: selectedColor.toARGB32(),
                                  shouldAddToExpense: shouldAddtoExpense,
                                  iconName: getIconNameByIcon(selectedIcon),
                                  hourTimeReminder: hourTimeReminder,
                                  minuteTimeReminder: minuteTimeReminder,
                                  notificationIdList:
                                      widget.habit.notificationIdList,
                                ),
                                shouldLoadAllHabits: false,
                              );
                              successToast(context, 'Habit updated!');
                            } else {
                              context.read<HabitCrudCubit>().addHabit(
                                name: nameController.text,
                                description: descriptionController.text,
                                repeatType: _selectedFrequency,
                                selectedDates: selectedDates,
                                selectedDays: selectedDays,
                                color: selectedColor,
                                iconName: getIconNameByIcon(selectedIcon),
                                shouldAddToExpense: shouldAddtoExpense,
                                hourTimeReminder: hourTimeReminder,
                                minuteTimeReminder: minuteTimeReminder,
                              );
                              successToast(context, 'Habit added!');
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text(widget.isUpadting ? 'Update' : 'Add'),
                      );
                    },
                  );
                },
              ),
            ),
            horizontalSpace(16),
            if (widget.isUpadting)
              ElevatedButton(
                onPressed: () async {
                  final result = await showDeleteBox(
                    context,
                    'Delete this habit?',
                  );
                  if (result == true) {
                    context.read<HabitCrudCubit>().deleteHabit(widget.habit);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    successToast(context, 'Habit deleted');
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOption({
    required String title,
    required String repeatType,
  }) {
    return BlocBuilder<ColorSelectorCubit, Color>(
      builder: (context, selectedColor) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                horizontalSpace(12),
                Radio(
                  activeColor: selectedColor,
                  value: repeatType,
                  groupValue: _selectedFrequency,
                  onChanged: (v) {
                    setState(() {
                      _selectedFrequency = v!;
                      selectedDays.clear();
                      selectedDates.clear();
                    });
                  },
                ),
                Text(title),
              ],
            ),
            if (repeatType == 'weekly')
              AnimatedOpacity(
                opacity: _selectedFrequency == 'weekly' ? 1 : 0,
                duration: Duration(milliseconds: 100),
                curve: Curves.fastEaseInToSlowEaseOut,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: _selectedFrequency == 'weekly' ? 50 : 0,
                  width: double.infinity,
                  curve: Curves.fastEaseInToSlowEaseOut,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ListView.builder(
                    itemCount: days.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: ChoiceChip(
                          labelPadding: EdgeInsets.all(2),
                          visualDensity: VisualDensity.compact,
                          label: Text(days[index]),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                          selected: selectedDays.contains(index + 1),
                          // selected: false,
                          onSelected: (value) {
                            setState(() {
                              if (selectedDays.contains(index + 1)) {
                                selectedDays.removeWhere(
                                  (day) => day == index + 1,
                                );
                              } else {
                                selectedDays.add(index + 1);
                              }
                            });
                          },
                          showCheckmark: false,
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: selectedColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (repeatType == 'monthly')
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastEaseInToSlowEaseOut,
                height: _selectedFrequency == 'monthly' ? 200 : 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: dates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChoiceChip(
                      labelPadding: EdgeInsets.all(2),
                      visualDensity: VisualDensity.compact,
                      label: Text(dates[index].toString()),
                      padding: EdgeInsets.symmetric(
                        horizontal: dates[index] < 10 ? 8 : 4,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      selected: selectedDates.contains(dates[index]),
                      onSelected: (value) {
                        setState(() {
                          if (selectedDates.contains(dates[index])) {
                            selectedDates.removeWhere(
                              (date) => date == dates[index],
                            );
                          } else {
                            selectedDates.add(dates[index]);
                          }
                        });
                      },
                      showCheckmark: false,
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: selectedColor,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
