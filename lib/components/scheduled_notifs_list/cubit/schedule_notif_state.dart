part of 'schedule_notif_cubit.dart';

sealed class ScheduleNotifState {}

final class ScheduleNotifLoading extends ScheduleNotifState {}

final class ScheduleNotifError extends ScheduleNotifState {
  final String errMessage;

  ScheduleNotifError(this.errMessage);
}

final class ScheduleNotifLoaded extends ScheduleNotifState {
  final List<PendingNotificationRequest> pendingScheduledNotifs;

  ScheduleNotifLoaded(this.pendingScheduledNotifs);
}
