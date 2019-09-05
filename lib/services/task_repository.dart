import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_crud/models/task.dart';

class TaskRepository {
  final CollectionReference ref = Firestore.instance.collection('Tasks');

  Stream<List<Task>> getFromDb() {
    Stream<QuerySnapshot> snapshots =
        ref.orderBy('createdAt', descending: true).snapshots();

    //turn the snapshot into a list.
    return snapshots.map((list) =>
        list.documents.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTask(Task task) {
    return ref.add(task.toMap());
  }

  Future<void> deleteTask(String id) {
    return ref.document(id).delete();
  }

  Future updateTask(Task task) {
    return ref.document(task.id).setData(task.toMap());
  }
}
