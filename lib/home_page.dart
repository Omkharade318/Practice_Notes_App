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

  // Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),

      // all notes viewed here
      body: allNotes.isNotEmpty
          ? ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                allNotes[index][DBHelper.COLUMN_NOTE_DESC],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: PopupMenuButton(
                onSelected: (value) async {
                  if (value == 'edit') {
                    titleController.text =
                    allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                    descController.text =
                    allNotes[index][DBHelper.COLUMN_NOTE_DESC];

                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      builder: (context) => bottomSheet(
                        isUpdate: true,
                        sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                      ),
                    );
                    getNotes();
                  } else if (value == 'delete') {
                    bool check = await dbRef!.deleteNote(
                        sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                    if (check) getNotes();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(
                      value: 'delete', child: Text("Delete")),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          "No Notes",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.clear();

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => bottomSheet(),
          );
          getNotes();
        },
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Bottom sheet for Add/Update note
  Widget bottomSheet({bool isUpdate = false, int sno = 0}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpdate ? "Update Note" : "Add Note",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      var title = titleController.text;
                      var desc = descController.text;

                      if (title.isNotEmpty && desc.isNotEmpty) {
                        bool check = isUpdate
                            ? await dbRef!.updateNote(
                            mTitle: title, mDesc: desc, sno: sno)
                            : await dbRef!
                            .addNote(mTitle: title, mDesc: desc);

                        if (check) {
                          getNotes();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Something went wrong")));
                        }

                        titleController.clear();
                        descController.clear();
                      }
                    },
                    child: Text(isUpdate ? "Update" : "Save"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
