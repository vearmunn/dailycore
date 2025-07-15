import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerCubit() : super(ImageInitial());

  Future<void> pickImage({required ImageSource source}) async {
    try {
      emit(ImageLoading());
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        emit(ImagePicked(pickedFile.path));
      } else {
        emit(ImageInitial()); // User canceled
      }
    } catch (e) {
      emit(ImageError("Failed to pick image: $e"));
    }
  }

  void setInitialImage(String path) {
    emit(ImagePicked(path));
  }

  void clearImage() {
    emit(ImageInitial());
  }
}
