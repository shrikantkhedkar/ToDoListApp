import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rbricks_test/controller/fireStoreController.dart';

import '../model/ToDoModel.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final ToDoControllerFirebase controller = ToDoControllerFirebase();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void clearController() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void submit(bool doEdit, [ToDoModel? obj]) async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty)
      return;

    if (doEdit && obj != null) {
      obj.title = titleController.text;
      obj.description = descriptionController.text;
      obj.date = dateController.text;
      await controller.updateToDoItem(obj);
    } else {
      await controller.addToDoItem(
        ToDoModel(
          title: titleController.text,
          description: descriptionController.text,
          date: dateController.text,
        ),
      );
    }
    clearController();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> cardColorList = [
      Color.fromRGBO(250, 232, 232, 1),
      Color.fromRGBO(232, 237, 250, 1),
      Color.fromRGBO(250, 249, 232, 1),
      Color.fromRGBO(250, 232, 250, 1),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do App"),
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ToDoModel>>(
        stream: controller.streamToDoItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final todolist = snapshot.data!;

          if (todolist.isEmpty) {
            return const Center(child: Text("No tasks found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: todolist.length,
            itemBuilder: (context, index) {
              final todo = todolist[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColorList[index % cardColorList.length],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/cardImage.png",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todo.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                todo.date,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () {
                                  titleController.text = todo.title;
                                  descriptionController.text = todo.description;
                                  dateController.text = todo.date;
                                  showBottomSheet(true, todo);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  if (todo.id != null)
                                    await controller.deleteToDoItem(todo.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        onPressed: () => showBottomSheet(false),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showBottomSheet(bool doEdit, [ToDoModel? obj]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                doEdit ? "Edit To-Do" : "Create To-Do",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    dateController.text = DateFormat.yMMMd().format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => submit(doEdit, obj),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
