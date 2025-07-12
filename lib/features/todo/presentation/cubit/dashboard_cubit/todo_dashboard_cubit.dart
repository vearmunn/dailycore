import 'package:flutter_bloc/flutter_bloc.dart';

class TodoDashboardCubit extends Cubit<int> {
  TodoDashboardCubit() : super((0));

  void changeTab(int index) => emit(index);
}
