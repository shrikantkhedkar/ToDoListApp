import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbricks_test/model/ToDoModel.dart';

class ToDoControllerFirebase {
  final CollectionReference todoCollection = FirebaseFirestore.instance
      .collection('todos');

  Future<List<ToDoModel>> getToDoItems() async {
    QuerySnapshot snapshot = await todoCollection.get();
    return snapshot.docs.map((doc) {
      return ToDoModel(
        id: doc.id.hashCode,
        title: doc['title'],
        description: doc['description'],
        date: doc['date'],
      );
    }).toList();
  }

  Future<void> addToDoItem(ToDoModel todo) async {
    await todoCollection.add({
      'title': todo.title,
      'description': todo.description,
      'date': todo.date,
    });
  }

  Future<void> updateToDoItem(String docId, ToDoModel todo) async {
    await todoCollection.doc(docId).update({
      'title': todo.title,
      'description': todo.description,
      'date': todo.date,
    });
  }

  Future<void> deleteToDoItem(String docId) async {
    await todoCollection.doc(docId).delete();
  }
}
