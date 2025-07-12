part of 'bar_graph_cubit.dart';

sealed class BarGraphState {}

final class BarGraphLoading extends BarGraphState {}

final class BarGraphLoaded extends BarGraphState {
  final Map<String, double> monthlyTotals;
  final int startMonth;
  final List<double> monthlySummary;

  BarGraphLoaded({
    required this.monthlyTotals,
    required this.startMonth,
    required this.monthlySummary,
  });
}

final class BarGraphError extends BarGraphState {
  final String errMessage;

  BarGraphError(this.errMessage);
}
