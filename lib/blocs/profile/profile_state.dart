import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileUploading extends ProfileState {}

class ProfileUploadSuccess extends ProfileState {
  final String downloadUrl;

  const ProfileUploadSuccess(this.downloadUrl);

  @override
  List<Object> get props => [downloadUrl];
}

class ProfileUploadFailure extends ProfileState {
  final String message;

  const ProfileUploadFailure(this.message);

  @override
  List<Object> get props => [message];
}
