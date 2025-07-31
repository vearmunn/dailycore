// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/components/pin/cubit/pin_cubit.dart';
import 'package:dailycore/features/home/homepage.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:dailycore/utils/spaces.dart';
import 'package:flutter/material.dart';

import 'package:dailycore/components/pin/pin_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../components/pin/pin_enum.dart';
import '../../localization/locales.dart';

class PinPage extends StatelessWidget {
  final PinEnum pinEnum;
  final bool isLastStepUpdating;
  const PinPage({
    super.key,
    this.pinEnum = PinEnum.isSettingUp,
    this.isLastStepUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          pinEnum == PinEnum.isLoggingIn
              ? null
              : AppBar(title: Text(getAppBarTitle(context))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pinEnum == PinEnum.isLoggingIn)
                Image.asset('assets/images/authentication.png', height: 300),
              Text(
                getTitle(context),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              verticalSpace(12),
              Text(
                getDescription(context),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              verticalSpace(30),
              BlocConsumer<PinCubit, PinState>(
                listener: (context, state) {
                  if (state is PinSaved) {
                    successToast(
                      context,
                      AppLocale.pinSaved.getString(context),
                    );
                    Navigator.pop(context);
                  }
                  if (state is PinCorrect && pinEnum == PinEnum.isLoggingIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  }
                  if (state is PinCorrect && pinEnum == PinEnum.isRemoving) {
                    context.read<PinCubit>().deletePin();
                    successToast(
                      context,
                      AppLocale.pinDeleted.getString(context),
                    );
                    Navigator.pop(context);
                  }
                  if (state is PinCorrect &&
                      pinEnum == PinEnum.isUpdating &&
                      isLastStepUpdating == false) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PinPage(
                              pinEnum: PinEnum.isUpdating,
                              isLastStepUpdating: true,
                            ),
                      ),
                    );
                  }
                  if (state is PinUpdated &&
                      pinEnum == PinEnum.isUpdating &&
                      isLastStepUpdating == true) {
                    successToast(
                      context,
                      AppLocale.pinUpdated.getString(context),
                    );
                    Navigator.pop(context);
                  }

                  if (state is PinIncorrect) {
                    errorToast(
                      context,
                      AppLocale.pinIncorrect.getString(context),
                    );
                  }
                },
                builder: (context, state) {
                  return MyPinInput(
                    onSubmitted: (value) async {
                      print(value);
                      if (pinEnum == PinEnum.isSettingUp) {
                        context.read<PinCubit>().savePin(value);
                      }
                      if (pinEnum == PinEnum.isLoggingIn) {
                        context.read<PinCubit>().verifyPin(value);
                      }
                      if (pinEnum == PinEnum.isRemoving) {
                        context.read<PinCubit>().verifyPin(value);
                      }
                      if (pinEnum == PinEnum.isUpdating) {
                        if (pinEnum == PinEnum.isUpdating &&
                            isLastStepUpdating) {
                          context.read<PinCubit>().updatePin(value);
                        } else {
                          await context.read<PinCubit>().verifyPin(value);
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTitle(BuildContext context) {
    switch (pinEnum) {
      case PinEnum.isSettingUp:
        return AppLocale.pinTitleSet.getString(context);
      case PinEnum.isUpdating:
        if (isLastStepUpdating) {
          return AppLocale.pinTitleUpdateNew.getString(context);
        } else {
          return AppLocale.pinTitleUpdateCurrent.getString(context);
        }
      case PinEnum.isRemoving:
        return AppLocale.pinTitleRemove.getString(context);
      case PinEnum.isLoggingIn:
        return AppLocale.pinTitleLogin.getString(context);
    }
  }

  String getAppBarTitle(BuildContext context) {
    switch (pinEnum) {
      case PinEnum.isSettingUp:
        return AppLocale.pinAppBarSet.getString(context);
      case PinEnum.isUpdating:
        return AppLocale.pinAppBarUpdate.getString(context);
      case PinEnum.isRemoving:
        return AppLocale.pinAppBarRemove.getString(context);
      case PinEnum.isLoggingIn:
        return AppLocale.pinAppBarLogin.getString(context);
    }
  }

  String getDescription(BuildContext context) {
    switch (pinEnum) {
      case PinEnum.isSettingUp:
        return AppLocale.pinDescSet.getString(context);
      case PinEnum.isUpdating:
        if (isLastStepUpdating) {
          return AppLocale.pinDescUpdateNew.getString(context);
        } else {
          return AppLocale.pinDescUpdateCurrent.getString(context);
        }
      case PinEnum.isRemoving:
        return AppLocale.pinDescRemove.getString(context);
      case PinEnum.isLoggingIn:
        return AppLocale.pinDescLogin.getString(context);
    }
  }
}
