part of 'image_picker_cubit.dart';

abstract class ImagePickerState {}

class ImageInitial extends ImagePickerState {}

class ImageLoading extends ImagePickerState {}

class ImagePicked extends ImagePickerState {
  final String imagePath;
  ImagePicked(this.imagePath);
}

class ImageError extends ImagePickerState {
  final String message;
  ImageError(this.message);
}
