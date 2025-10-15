import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rbricks_test/controller/toDoController.dart';
import 'package:rbricks_test/model/ToDoModel.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Map> cardList = await ToDoController().getToDoItem();
    log("CARD LIST: $cardList");
    for (var element in cardList) {
      todolist.add(
        ToDoModel(
          date: element['date'],
          description: element['description'],
          title: element['title'],
          id: element['id'],
        ),
      );
    }
    setState(() {});
  }

  List<ToDoModel> todolist = [
    ToDoModel(
      title: "Flutter",
      description: "dart, flutter",
      date: "12 Aug 2024",
    ),
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List cardColorList = [
    Color.fromRGBO(250, 232, 232, 1),
    Color.fromRGBO(232, 237, 250, 1),

    Color.fromRGBO(250, 249, 232, 1),

    Color.fromRGBO(250, 232, 250, 1),
  ];
  void clearController() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  Future<void> submit(bool doEdit, [ToDoModel? obj]) async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty) {
      if (doEdit && obj != null) {
        obj.title = titleController.text;
        obj.description = descriptionController.text;
        obj.date = dateController.text;

        Map<String, dynamic> mapObj = {
          "title": obj.title,
          "description": obj.description,
          "date": obj.date,
          "id": obj.id,
        };
        await ToDoController().updateToDoItem(mapObj);
      } else {
        todolist.add(
          ToDoModel(
            title: titleController.text,
            description: descriptionController.text,
            date: dateController.text,
          ),
        );
        Map<String, dynamic> dataMap = {
          'title': titleController.text,
          "description": descriptionController.text,
          "date": dateController.text,
        };
        ToDoController().insertToDoItem(dataMap);
      }
      clearController();
      setState(() {});
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: todolist.length,
        padding: const EdgeInsets.all(12),
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
                // Circular Image
                Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/cardImage.png", // make sure this file exists
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

                // Text + Date + Icons
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Description
                      Text(
                        todo.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Date + Edit/Delete icons
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
                            icon: const Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              titleController.text = todo.title;
                              descriptionController.text = todo.description;
                              dateController.text = todo.date;

                              showBottomSheet(true, todo);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              if (todo.id != null) {
                                await ToDoController().deleteToDoItem(todo.id!);
                              }

                              setState(() {
                                todolist.removeAt(index);
                              });
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        onPressed: () {
          showBottomSheet(false);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showBottomSheet(bool doEdit, [ToDoModel? obj]) {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create To-Do",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter your title",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter your description",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                hintText: "Enter your date",
                suffixIcon: Icon(Icons.calendar_view_month_outlined),
              ),
              /*  onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2016),
                );
                dateController.text = DateFormat.yMMMd().format(pickedDate!);
           },  */
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2026),
                  initialDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  dateController.text = DateFormat.yMMMd().format(pickedDate);
                }
              },
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  fixedSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (doEdit) {
                    submit(doEdit, obj);
                  } else {
                    submit(doEdit);
                  }
                },

                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
