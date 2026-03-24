import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String uid, XFile imageFile) async {
    try {
      final ref = _storage.ref().child('user_profiles').child('$uid.jpg');

      final data = await imageFile.readAsBytes();
      final uploadTask = ref.putData(
        data,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
  }
}
