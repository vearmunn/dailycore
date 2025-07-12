import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<DateTime?> {
  DateCubit() : super(null);

  void setDate(DateTime? date) => emit(date);
  void clearDate() => emit(null);
}
