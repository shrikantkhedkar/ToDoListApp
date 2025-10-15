class ToDoModel {
  String title;
  String description;
  String date;
  String? id;

  ToDoModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}
