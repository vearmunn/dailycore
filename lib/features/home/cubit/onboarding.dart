// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dailycore/consts/prefs_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<bool> {
  final SharedPreferences prefs;
  OnboardingCubit(this.prefs) : super(true) {
    loadStatus();
  }

  void loadStatus() {
    final show = prefs.getBool(showOnboardingPageKey) ?? true;
    emit(show);
  }

  Future completeOnboarding() async {
    await prefs.setBool(showOnboardingPageKey, false);
    emit(false);
  }
}
