import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StorageService _storageService;
  final AuthService _authService;

  ProfileBloc({
    required StorageService storageService,
    required AuthService authService,
  }) : _storageService = storageService,
       _authService = authService,
       super(ProfileInitial()) {
    on<UploadProfileImage>(_onUploadProfileImage);
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUploading());
    try {
      final downloadUrl = await _storageService.uploadProfileImage(
        event.uid,
        event.image,
      );
      await _authService.updateProfilePhoto(downloadUrl);
      emit(ProfileUploadSuccess(downloadUrl));
    } catch (e) {
      emit(ProfileUploadFailure(e.toString()));
    }
  }
}
