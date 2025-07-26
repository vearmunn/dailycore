import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
part 'schedule_notif_state.dart';

class ScheduleNotifCubit extends Cubit<ScheduleNotifState> {
  ScheduleNotifCubit() : super(ScheduleNotifLoading()) {
    checkPendingNotifications();
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future checkPendingNotifications() async {
    try {
      emit(ScheduleNotifLoading());
      final List<PendingNotificationRequest> pendingNotifications =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      emit(ScheduleNotifLoaded(pendingNotifications));
    } catch (e) {
      emit(ScheduleNotifError(e.toString()));
    }
  }

  Future cancelAllSchedules() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      checkPendingNotifications();
    } catch (e) {
      emit(ScheduleNotifError(e.toString()));
    }
  }

  Future cancelNotification(int notificationId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(notificationId);
      checkPendingNotifications();
    } catch (e) {
      emit(ScheduleNotifError(e.toString()));
    }
  }
}
