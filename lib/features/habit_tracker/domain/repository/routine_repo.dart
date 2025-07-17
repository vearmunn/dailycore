import '../models/routine.dart';

abstract class RoutineRepo {
  Future<List<Routine>> getRoutines();

  Future<Routine> getSingleRoutine(int id);

  Future addRoutine(Routine newRoutine);

  Future updateRoutine(Routine routine);

  Future deleteRoutine(int id);

  Future addSubHabit(int id, SubHabit newSubHabit);

  Future updateSubHabit(int id, SubHabit subHabit);

  Future toggleSubHabit(int id, SubHabit subHabit, {DateTime? selectedDay});

  Future deleteSubHabit(int id, int idSubHabit);
}
