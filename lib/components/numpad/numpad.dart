import 'package:dailycore/utils/colors_and_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'numpad_cubit.dart';

class NumberPad extends StatelessWidget {
  final bool showDecimal;

  const NumberPad({super.key, this.showDecimal = true});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      showDecimal ? '.' : '',
      '0',
      '⌫',
    ];

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(4),
      childAspectRatio: 3,
      children:
          keys.map((key) {
            if (key == '') return const SizedBox.shrink();

            return ElevatedButton(
              onPressed: () {
                final cubit = context.read<NumpadCubit>();
                if (key == '⌫') {
                  cubit.backspace();
                } else {
                  cubit.input(key);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dailyCoreCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
              ),
              child: Text(key, style: const TextStyle(fontSize: 18)),
            );
          }).toList(),
    );
  }
}
