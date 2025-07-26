import 'package:dailycore/components/scheduled_notifs_list/cubit/schedule_notif_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduledNotifsListPage extends StatefulWidget {
  const ScheduledNotifsListPage({super.key});

  @override
  State<ScheduledNotifsListPage> createState() =>
      _ScheduledNotifsListPageState();
}

class _ScheduledNotifsListPageState extends State<ScheduledNotifsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scheduled Notifications')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            child: Text('Check Pending Notifications'),
            onPressed:
                () =>
                    context
                        .read<ScheduleNotifCubit>()
                        .checkPendingNotifications(),
          ),
          ElevatedButton(
            child: Text('Cancel All Pending Notifications'),
            onPressed:
                () => context.read<ScheduleNotifCubit>().cancelAllSchedules(),
          ),
          BlocBuilder<ScheduleNotifCubit, ScheduleNotifState>(
            builder: (context, state) {
              if (state is ScheduleNotifLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ScheduleNotifError) {
                return Center(child: Text(state.errMessage));
              }
              if (state is ScheduleNotifLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.pendingScheduledNotifs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final schedule = state.pendingScheduledNotifs[index];
                    return ListTile(
                      title: Text('Body: ${schedule.body}'),
                      trailing: Text('ID: ${schedule.id}'),
                      subtitle: Text('Payload: ${schedule.payload}'),
                    );
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
