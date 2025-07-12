part of 'heatmap_cubit.dart';

sealed class HeatmapState {}

final class GetStartDateLoading extends HeatmapState {}

final class GetStartDateLoaded extends HeatmapState {
  final DateTime startDate;

  GetStartDateLoaded(this.startDate);
}

final class GetStartDateError extends HeatmapState {
  final String errMessage;

  GetStartDateError(this.errMessage);
}
