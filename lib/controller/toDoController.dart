import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ToDoController {
  Future<Database> createDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "TodoDB.db"),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
create table Todo(
  id integer primary key autoincrement,
  title text,
  description text,
  date text
)
''');
      },
    );
    return db;
  }

  Future<List<Map>> getToDoItem() async {
    Database localdb = await createDB();
    List<Map> list = await localdb.query("Todo");
    return list;
  }

  void insertToDoItem(Map<String, dynamic> obj) async {
    Database localdb = await createDB();
    await localdb.insert(
      "Todo",
      obj,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateToDoItem(Map<String, dynamic> obj) async {
    Database localdb = await createDB();
    await localdb.update("Todo", obj, where: "id=?", whereArgs: [obj['id']]);
  }

  Future<void> deleteToDoItem(int index) async {
    Database localdb = await createDB();
    await localdb.delete("Todo", where: "id=?", whereArgs: [index]);
  }
}
