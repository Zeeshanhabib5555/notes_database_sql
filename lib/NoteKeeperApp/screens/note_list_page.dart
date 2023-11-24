import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/data_base_helper.dart';
import '../models/note.dart';
import 'note_detail_page.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Note>? notelist;

  // int count = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (notelist == null) {
      notelist = <Note>[];
      updateListView();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FAB clicked");
          navigateToDetail(Note('', '', 2, ""), "Add Note",'save');
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  getNoteListView() {
    TextStyle? tileStyle = Theme.of(context).textTheme.headline6;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.notelist![position].priority),
              child: getPriorityIcon(this.notelist![position].priority),
            ),
            title: Text(
              this.notelist![position].title,
              style: tileStyle,
            ),
            subtitle: Text(
              this.notelist![position].date,
              style: tileStyle,
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _delete(context, notelist![position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile tapped");
              navigateToDetail((this.notelist![position]), "Edit Note",'update');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> navigateToDetail(Note note, String title,String buttonText) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint("$title");
      debugPrint("$note");
      return NoteDetail(note, title,buttonText);
    }));

    if (result == true) {
      updateListView();
    } else {
      debugPrint("updated list view using else statement");
      updateListView();
    }
  }

  void updateListView() {
    debugPrint("update listView called");
    final Future<Database?> dbFuture = databaseHelper.initializedDataBase();
    dbFuture.then((database) {
      debugPrint("$notelist");

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.notelist = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

//
// class NoteList extends StatefulWidget {
//   const NoteList({super.key});
//
//   @override
//   State<NoteList> createState() => _NoteListState();
// }
//
// class _NoteListState extends State<NoteList> {
//   DataBaseHelper databaseHelper = DataBaseHelper();
//   List<Note>? noteList;
//   int count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     // noteList ??= List<Note>.empty(growable: true);
//
//     if (noteList == null) {
//       noteList = List<Note>.empty(growable: true);
//       updateListView();
//     }
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text(
//             'Notes',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: getNoteListview(),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.deepPurple,
//           onPressed: () {
//             navigationToDetail(Note('', '', 1), 'Edit Note');
//             // navigationToDetail('Add Note');
//           },
//           child: const Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Padding getNoteListview() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView.builder(
//         itemCount: count,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 2,
//             color: Colors.white,
//             child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: getPriorityColor(noteList![index].priority),
//                   child: getPriorityIcon(noteList![index].priority),
//                 ),
//                 title: Text(
//                   noteList![index].title,
//                   style: const TextStyle(color: Colors.black, fontSize: 22),
//                 ),
//                 subtitle: Text(noteList![index].date),
//                 trailing: GestureDetector(
//                   child: const Icon(
//                     Icons.delete,
//                     color: Colors.grey,
//                   ),
//                   onTap: () {
//                     _delete(context, noteList![index]);
//                   },
//                 ),
//                 onTap: () {
//                   print('Ont-ap');
//                   navigationToDetail(noteList![index], 'Edit Note');
//                 }),
//           );
//         },
//       ),
//     );
//   }
//
//   // Returns the priority color
//   Color getPriorityColor(int priority) {
//     switch (priority) {
//       case 1:
//         return Colors.red;
//         break;
//       case 2:
//         return Colors.yellow;
//         break;
//
//       default:
//         return Colors.yellow;
//     }
//   }
//
//   // Returns the priority icon
//   Icon getPriorityIcon(int priority) {
//     switch (priority) {
//       case 1:
//         return const Icon(Icons.play_arrow);
//         break;
//       case 2:
//         return const Icon(Icons.keyboard_arrow_right);
//         break;
//
//       default:
//         return const Icon(Icons.keyboard_arrow_right);
//     }
//   }
//
//   void _delete(BuildContext context, Note note) async {
//     int? result = await databaseHelper.deleteNote(note.id ?? 0);
//
//     // int result = await databaseHelper.deleteNote(note.id);
//     if (result != 0) {
//       _showSnackBar(context, 'Note Deleted Successfully');
//       updateListView();
//     }
//   }
//
//   void _showSnackBar(BuildContext context, String message) {
//     final snackBar = SnackBar(content: Text(message));
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   void navigationToDetail(Note note, String title) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NoteDetail(note, title),
//       ),
//     );
//   }
//
//   void updateListView() {
//     final Future<Database?> dbFuture = databaseHelper.initializedDataBase();
//     dbFuture.then((database) {
//       Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
//       noteListFuture.then((noteList) {
//         setState(() {
//           this.noteList = noteList;
//           count = noteList.length;
//         });
//       });
//     });
//   }
// }
