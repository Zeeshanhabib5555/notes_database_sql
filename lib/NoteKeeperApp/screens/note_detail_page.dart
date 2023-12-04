import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/data_base_helper.dart';
import '../models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  final String buttonText;

  NoteDetail(this.note, this.appBarTitle, this.buttonText);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static final _priorities = ['Low', 'High'];

  DataBaseHelper helper = DataBaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    // Initialize note if it's null
    note ??= Note('', '', 1, ''); // Adjust the default values as needed
    titleController.text = note!.title;
    descriptionController.text = note!.description;
  }

  @override
  Widget build(BuildContext context) {
    // titleController.text = note?.title ?? '';
    // descriptionController.text = note?.description ?? '';

    return WillPopScope(
        onWillPop: () async {
          moveToLastScreen();
          return Future.value(true); // Return a completed future with false
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Center(child: Text(appBarTitle)),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                Container(
                  height: 60,
                  // width: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF26A69A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem,style: TextStyle(fontSize: 20),),
                          );
                        }).toList(),
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser!);
                          });
                        }),
                  ),
                ),

                // Second Element
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                 Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xFF4DB6AC)),
                          ),
                          // color: Theme.of(context).primaryColorDark,
                          // textColor: Theme.of(context).primaryColorLight,
                          child:  Text(
                            widget.buttonText,
                            textScaleFactor: 1.5,style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                          ),
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String? priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority!;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note?.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    // WidgetsFlutterBinding.ensureInitialized(); // Add this line
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int? result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int? result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: Color(0xFFB2DFDB),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_uraan/NoteKeeperApp/models/note.dart';
//
// import '../Utils/data_base_helper.dart';
//
// class NoteDetail extends StatefulWidget {
//   String? appBarTitle;
//   Note? note;
//
//   NoteDetail({this.note, this.appBarTitle, super.key});
//
//   @override
//   State<NoteDetail> createState() => _NoteDetailState();
// }
//
// class _NoteDetailState extends State<NoteDetail> {
//   static final _priorities = ['High', 'Low'];
//   DataBaseHelper helper = DataBaseHelper();
//
//   String? appBarTitle;
//   Note? note;
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     titleController.text = widget.note!.title;
//     descriptionController.text = widget.note!.description;
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () async {
//           moveToLAstScreen();
//           return Future.value(true); // Return a completed future with false
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   moveToLAstScreen();
//                 },
//                 icon: const Icon(Icons.arrow_back)),
//             backgroundColor: Colors.deepPurple,
//             title: Text(
//               widget.appBarTitle.toString(),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: ListView(
//               children: [
//                 ///
//                 ///
//                 /// First Element
//                 ///
//                 ///
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(top: 15.0, left: 10, right: 10),
//                   child: ListTile(
//                     title: DropdownButton(
//                       items: _priorities.map((e) {
//                         return DropdownMenuItem(
//                           value: e,
//                           child: Text(e.toString()),
//                         );
//                       }).toList(),
//                       value: _priorities.first,
//                       onChanged: (valueSelectedByUser) {
//                         setState(() {
//                           print('User Selected $valueSelectedByUser');
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//
//                 ///
//                 ///
//                 /// 2nd Element
//                 ///
//                 ///
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15.0),
//                   child: TextField(
//                     controller: titleController,
//                     onChanged: (value) {},
//                     decoration: InputDecoration(
//                       labelText: 'Title',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 ///
//                 ///
//                 /// 3rd Element
//                 ///
//                 ///
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15.0),
//                   child: TextField(
//                     controller: descriptionController,
//                     onChanged: (value) {},
//                     decoration: InputDecoration(
//                       labelText: 'Description',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15.0),
//                   child: Row(
//                     children: [
//                       CupertinoButton(
//                         onPressed: () {},
//                         color: Colors.deepPurple,
//                         child: const Text('Save'),
//                       ),
//                       const SizedBox(width: 5),
//                       CupertinoButton(
//                         onPressed: () {},
//                         color: Colors.deepPurple,
//                         child: const Text('Delete'),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void moveToLAstScreen() {
//     Navigator.pop(context);
//   }
//
//   // Convert the String priority in the form of integer before saving it to Database
//   void updatePriorityAsInt(String value) {
//     switch (value) {
//       case 'High':
//         note!.priority = 1;
//         break;
//       case 'Low':
//         note!.priority = 2;
//         break;
//     }
//   }
//
//   // Convert int priority to String priority and display it to user in DropDown
//   int getPriorityAsString(int value) {
//     String priority;
//     switch (value) {
//       case 1:
//         priority = _priorities[0]; // 'High'
//         break;
//       case 2:
//         priority = _priorities[1]; // 'Low'
//         break;
//     }
//     return priority;
//   }
//
//   // Update the title of Note object
//   void updateTitle() {
//     note!.title = titleController.text;
//   }
// }
