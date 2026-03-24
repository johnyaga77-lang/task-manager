import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UploadProfileImage extends ProfileEvent {
  final XFile image;
  final String uid;

  const UploadProfileImage({required this.image, required this.uid});

  @override
  List<Object> get props => [image, uid];
}
