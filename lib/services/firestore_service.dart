import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  FirestoreService({required this.uid});

  // Database References
  CollectionReference get _tasksRef =>
      _db.collection('users').doc(uid).collection('tasks');

  CollectionReference get _notesRef =>
      _db.collection('users').doc(uid).collection('notes');

  // --- TASKS ---

  Stream<List<Task>> getTasksStream() {
    return _tasksRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addTask(Task task) async {
    await _tasksRef.doc(task.id).set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _tasksRef.doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }

  Future<void> toggleTaskCompletion(String taskId, bool currentStatus) async {
    await _tasksRef.doc(taskId).update({'isCompleted': !currentStatus});
  }

  // --- NOTES ---

  Stream<List<Note>> getNotesStream() {
    return _notesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addNote(Note note) async {
    await _notesRef.doc(note.id).set(note.toJson());
  }

  Future<void> updateNote(Note note) async {
    await _notesRef.doc(note.id).update(note.toJson());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesRef.doc(noteId).delete();
  }
}
