// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:currency_textfield/currency_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dailycore/components/date_picker/pick_date.dart';
import 'package:dailycore/components/image_picker/image_picker_cubit.dart';
import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:dailycore/utils/spaces.dart';

import '../../../../components/date_picker/pick_date_cubit.dart';
import '../../../../utils/custom_toast.dart';
import '../../domain/models/goal.dart';
import '../cubit/goal/goal_cubit.dart';

class GoalAddEditPage extends StatefulWidget {
  const GoalAddEditPage({super.key, this.goal, this.isUpdating = false});

  final Goal? goal;
  final bool isUpdating;

  @override
  State<GoalAddEditPage> createState() => _GoalAddEditPageState();
}

class _GoalAddEditPageState extends State<GoalAddEditPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late CurrencyTextFieldController amountController;
  bool showDatePicker = false;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = CurrencyTextFieldController(
      currencySymbol: 'Rp',
      currencySeparator: ' ',
      numberOfDecimals: 0,
    );

    if (widget.isUpdating) {
      titleController.text = widget.goal!.title;
      descriptionController.text = widget.goal!.description ?? '';
      amountController.text = widget.goal!.targetAmount.toInt().toString();
      context.read<ImagePickerCubit>().setInitialImage(widget.goal!.imagePath);
      if (widget.goal!.deadline != null) {
        showDatePicker = true;
        context.read<DateCubit>().setDate(widget.goal!.deadline);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdating ? 'Edit Goal' : 'Add Goal'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          verticalSpace(16),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          verticalSpace(16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Target Amount'),
          ),
          verticalSpace(16),
          Row(
            children: [
              Checkbox(
                value: showDatePicker,
                visualDensity: VisualDensity.compact,
                onChanged: (v) {
                  setState(() {
                    showDatePicker = !showDatePicker;
                  });
                },
              ),
              Text('Set deadline'),
            ],
          ),
          verticalSpace(16),
          if (showDatePicker) customDatePicker(context, DateTime.now()),
          if (showDatePicker) verticalSpace(16),
          _buildImagePicker(context),
          verticalSpace(16),
          BlocBuilder<DateCubit, DateTime?>(
            builder: (context, selectedDate) {
              return BlocBuilder<ImagePickerCubit, ImagePickerState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        errorToast(context, 'Title must not be empty!');
                      } else if (amountController.text.isEmpty) {
                        errorToast(context, 'Amount must not be empty!');
                      } else {
                        if (state is ImagePicked) {
                          if (widget.isUpdating) {
                            context.read<GoalCubit>().updateGoal(
                              Goal(
                                id: widget.goal!.id,
                                title: titleController.text,
                                description: descriptionController.text,
                                deadline: showDatePicker ? selectedDate : null,
                                imagePath: state.imagePath,
                                targetAmount: amountController.doubleValue,
                                currentAmount: widget.goal!.currentAmount,
                              ),
                            );
                            successToast(context, 'Goal updated!');
                          } else {
                            context.read<GoalCubit>().addNewGoal(
                              context,
                              title: titleController.text,
                              description: descriptionController.text,
                              targetAmount: amountController.doubleValue,
                              deadline: showDatePicker ? selectedDate : null,
                              imagePath: state.imagePath,
                            );
                            successToast(context, 'Goal added!');
                          }
                          context.read<ImagePickerCubit>().clearImage();
                          Navigator.pop(context);
                        } else {
                          errorToast(context, 'Please select an image!');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dailyCoreBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text(widget.isUpdating ? 'Update' : 'Add'),
                  );
                },
              );
            },
          ),
          verticalSpace(16),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap:
          () => showModalBottomSheet(
            context: context,
            builder:
                (context) => Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          context.read<ImagePickerCubit>().pickImage(
                            source: ImageSource.camera,
                          );
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                      Divider(),
                      TextButton.icon(
                        onPressed: () {
                          context.read<ImagePickerCubit>().pickImage(
                            source: ImageSource.gallery,
                          );
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.photo_library_rounded),
                        label: Text('Gallery'),
                      ),
                    ],
                  ),
                ),
          ),
      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
        builder: (context, state) {
          if (state is ImagePicked) {
            return Container(child: Image.file(File(state.imagePath)));
          }
          if (state is ImageLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ImageError) {
            return Center(child: Text(state.message));
          }
          return DottedBorder(
            padding: EdgeInsets.symmetric(vertical: 30),
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: [6, 3],
            color: Colors.grey.shade400,
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.grey.shade400,
                    size: 35,
                  ),
                  verticalSpace(12),
                  Text(
                    'Pick an image of the item you’re saving for',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
