


import 'package:medicine_alarm/model/medicine_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseConnection {
  static Future<Database> SetDatabase() async{
   var directory = await getDatabasesPath();
   String path = join(directory, 'demo.db');
   var database= await
    openDatabase(path,version: 1,onCreate: _oncreate);
   return database;

}

static _oncreate(Database database,int version )async{
   await database.execute("CREATE TABLE medicines(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,hour INTEGER,minute INTEGER,imageFile TEXT,selectedshow TEXT,datefrompicker TEXT)");
 }


 saveitem(Medicine medicine)async {
    final db =await SetDatabase();
    final int id=await db.insert('medicines', medicine.medicine_to_map()); //تلقائي بيبقي فيه id
    return id;
 }



  Future deleteItem(int id)async{
    final db=await SetDatabase();
    var count = await db
        .rawDelete('DELETE FROM medicines WHERE id ="$id"');
    return count;

 }

 Future<List<Map<String,dynamic>>>getdatabase()async{
    final db=await SetDatabase();
    return db.query('medicines');
 }

}

