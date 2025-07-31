// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../consts/prefs_key.dart';

part 'pin_state.dart';

class PinCubit extends Cubit<PinState> {
  final SharedPreferences prefs;
  PinCubit(this.prefs) : super(PinInitial());

  Future<void> savePin(String pin) async {
    await prefs.setString(pinKey, pin);
    emit(PinSaved());
  }

  Future<void> updatePin(String pin) async {
    await prefs.setString(pinKey, pin);
    emit(PinUpdated());
  }

  Future<void> deletePin() async {
    await prefs.remove(pinKey);
    emit(PinDeleted());
  }

  Future<void> verifyPin(String input) async {
    final storedPin = prefs.getString(pinKey);

    if (storedPin == null) {
      emit(PinNotSet());
    } else if (storedPin == input) {
      emit(PinCorrect());
    } else {
      emit(PinIncorrect());
    }
  }

  bool isPinSet() {
    return prefs.containsKey(pinKey);
  }
}
