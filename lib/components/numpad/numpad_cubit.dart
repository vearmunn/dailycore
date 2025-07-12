import 'package:flutter_bloc/flutter_bloc.dart';

class NumpadCubit extends Cubit<String> {
  NumpadCubit() : super('');

  void input(String value) {
    if (value == '.' && state.contains('.')) return;
    emit(state + value);
  }

  void backspace() {
    if (state.isNotEmpty) {
      emit(state.substring(0, state.length - 1));
    }
  }

  void clear() => emit('');

  String get value => state;
}
