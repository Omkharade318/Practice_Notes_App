import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  // Singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  // Table
  static final String TABLE_NOTE = "notes";
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";

  Database? myDB;

  // DB Open()
  // path -> if exists then open else create db
  Future<Database> getDB() async{

    // if(myDB != null){
    //   return myDB!;
    // } else {
    //   myDB = await openDB();
    //   return myDB!;
    // }

    myDB ??= await openDB(); // same as above but shorter
    return myDB!;
  }

  Future<Database> openDB() async{

    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version){
        // Create Table
        db.execute("CREATE TABLE $TABLE_NOTE ($COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_NOTE_TITLE TEXT, $COLUMN_NOTE_DESC TEXT)");
    }, version: 1);
  }

  // Queries

  // Insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async{

    var db = await getDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc
    });

    return rowsEffected > 0;
  }

  // Reading all Data
  Future<List<Map<String, dynamic>>> getAllNotes() async{

    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);  // SELECT * FROM TABLE_NOTE

    return mData;
  }

  // Update Data
  Future<bool> updateNote({required String mTitle, required String mDesc, required int sno}) async{
    var db = await getDB();

    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc
    }, where: "$COLUMN_NOTE_SNO = $sno");

    return rowsEffected > 0;
  }

  // Delete Note
  Future<bool> deleteNote({required int sno}) async{
    var db = await getDB();

    int rowsEffected = await db.delete(TABLE_NOTE,
        where: "$COLUMN_NOTE_SNO = ?", whereArgs: ['$sno']);

    return rowsEffected > 0;
  }

}