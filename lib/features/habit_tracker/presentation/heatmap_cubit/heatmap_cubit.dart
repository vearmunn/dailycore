// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dailycore/features/habit_tracker/domain/repository/app_settings_repo.dart';

part 'heatmap_state.dart';

class HeatmapCubit extends Cubit<HeatmapState> {
  final AppSettingsRepo appSettingsRepo;
  HeatmapCubit(this.appSettingsRepo) : super(GetStartDateLoading()) {
    getStartDate();
  }

  Future getStartDate() async {
    try {
      emit(GetStartDateLoading());
      final startDate = await appSettingsRepo.getFirstLaunchDate();
      emit(GetStartDateLoaded(startDate ?? DateTime.now()));
    } catch (e) {
      emit(GetStartDateError(e.toString()));
    }
  }
}
