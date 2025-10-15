import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ToDoModel.dart';

class ToDoControllerFirebase {
  final CollectionReference<Map<String, dynamic>> todoCollection =
      FirebaseFirestore.instance.collection('todos');

  // Real-time stream
  Stream<List<ToDoModel>> streamToDoItems() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ToDoModel(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          date: doc['date'],
        );
      }).toList();
    });
  }

  // Add ToDo
  Future<void> addToDoItem(ToDoModel todo) async {
    DocumentReference docRef = await todoCollection.add({
      'title': todo.title,
      'description': todo.description,
      'date': todo.date,
    });
    todo.id = docRef.id;
  }

  // Update ToDo
  Future<void> updateToDoItem(ToDoModel todo) async {
    if (todo.id != null) {
      await todoCollection.doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
        'date': todo.date,
      });
    }
  }

  // Delete ToDo
  Future<void> deleteToDoItem(String docId) async {
    await todoCollection.doc(docId).delete();
  }
}
