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
        onPressed: () async {
          // wait for bottom sheet to close
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetView();
            },
          );

          // refresh notes after sheet is closed
          getNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

}

class BottomSheetView extends StatefulWidget{
  const BottomSheetView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetViewState();
  }
}

class _BottomSheetViewState extends State<BottomSheetView> {

  // Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];

  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
    setState(() {

    });
  }

  void getNotes() async{
    allNotes = await dbRef!.getAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Column(
        children: [
          Text("Add Note", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(height: 20,),

          TextField(
            controller: titleController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: "Enter title here",
                label: Text("Title")
            ),

          ),

          SizedBox(height: 20,),

          TextField(
            controller: descController,
            maxLines: 5,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: "Enter Description here",
                label: Text("Description")
            ),
          ),

          SizedBox(height: 20,),

          Row(
            children: [
              Expanded(child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              width: 4,
                              color: Colors.black
                          )
                      )
                  ),
                  onPressed: () async{
                    var title = titleController.text;
                    var desc = descController.text;

                    if(title.isNotEmpty && desc.isNotEmpty){
                      bool check = await dbRef!.addNote(mTitle: title, mDesc: desc);
                      if(check){
                        getNotes();
                        setState(() {

                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
                      }

                      titleController.clear();
                      descController.clear();

                      // close the bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save Note"))
              ),

              SizedBox(width: 10,),

              Expanded(child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              width: 4,
                              color: Colors.black
                          )
                      )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))),
            ],
          )

        ],
      ),
    );
  }

}