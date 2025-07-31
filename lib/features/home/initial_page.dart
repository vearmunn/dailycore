import 'package:dailycore/components/pin/cubit/pin_cubit.dart';
import 'package:dailycore/components/pin/pin_enum.dart';
import 'package:dailycore/features/home/homepage.dart';
import 'package:dailycore/features/home/pin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPinSet = context.read<PinCubit>().isPinSet();
    if (isPinSet) {
      return PinPage(pinEnum: PinEnum.isLoggingIn);
    } else {
      return Homepage();
    }
  }
}
