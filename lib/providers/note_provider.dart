import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  StreamSubscription<List<Note>>? _notesSubscription;
  FirestoreService? _firestoreService;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _notesSubscription?.cancel();
      if (user != null) {
        _firestoreService = FirestoreService(uid: user.uid);
        _isLoading = true;
        notifyListeners();

        _notesSubscription = _firestoreService!.getNotesStream().listen(
          (notes) {
            _notes = notes;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint("Error listening to note stream: $error");
            _isLoading = false;
            notifyListeners();
          },
        );
      } else {
        _notes = [];
        _firestoreService = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }

  Future<void> addNote(Note note) async {
    await _firestoreService?.addNote(note);
  }

  Future<void> updateNote(Note note) async {
    await _firestoreService?.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _firestoreService?.deleteNote(id);
  }
}
