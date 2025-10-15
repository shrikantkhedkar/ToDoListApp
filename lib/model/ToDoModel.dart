class ToDoModel {
  String title;
  String description;
  String date;
  int id;

  ToDoModel({
    this.id = 0,
    required this.title,
    required this.description,
    required this.date,
  });
}
