import 'package:database/data/local/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> allNotes = [];

  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async{
    allNotes = await dbRef!.getAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      // all notes viewed here
      body: allNotes.isNotEmpty ? ListView.builder(
          itemCount: allNotes.length,
          itemBuilder: (_, index){
            return ListTile(
              leading: Text("${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}"),
              title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
              subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
            );
      }) : Center(
        child: Text("No Notes"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // note to be added from here
          bool check = await dbRef!.addNote(mTitle: "Personal Fav Note", mDesc: "This is a personal favorite note");
          if(check) {
            getNotes();
          }
      },
        child: Icon(Icons.add),
      ),
    );
  }


}