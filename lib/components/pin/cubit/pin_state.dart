// pin_state.dart
part of 'pin_cubit.dart';

abstract class PinState {}

class PinInitial extends PinState {}

class PinSaved extends PinState {}

class PinUpdated extends PinState {}

class PinDeleted extends PinState {}

class PinCorrect extends PinState {}

class PinIncorrect extends PinState {}

class PinNotSet extends PinState {}
