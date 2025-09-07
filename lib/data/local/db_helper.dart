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

}