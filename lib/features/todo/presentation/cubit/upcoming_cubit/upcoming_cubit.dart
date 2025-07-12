import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingDateCubit extends Cubit<DateTime?> {
  UpcomingDateCubit() : super(null);

  void setUpcomingDate(DateTime? date) => emit(date);
  void clearDate() => emit(null);
}
