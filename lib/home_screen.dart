import 'package:flutter/material.dart';
import 'package:notes_database_sql/db_handler.dart';
import 'package:notes_database_sql/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData ();
  }
  loadData ()async{
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Notes SQL"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: notesList,
                  builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              setState(() {
                                notesList=dbHelper!.getNotesList();
                              });
                              dbHelper?.update(
                                  NotesModel(
                                      id: snapshot.data![index].id!,
                                      title: 'title', email: 'email', age: 3, description: 'description')
                              );
                            },
                            child: Dismissible(
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.redAccent,
                                child: const Icon(Icons.delete_forever),
                              ),
                              onDismissed: (DismissDirection direction){
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);

                                });
                              },

                              key: ValueKey<int>(snapshot.data![index].id!),
                              child: Card(
                                child: ListTile(
                                  contentPadding:const EdgeInsets.all(0),
                                  title: Text(snapshot.data![index].title.toString()),
                                  subtitle: Text(snapshot.data![index].description.toString()),
                                  trailing: Text(snapshot.data![index].age.toString()),
                                ),
                              ),
                            ),
                          );
                        });
                  }else{
                    return const CircularProgressIndicator();
                  }

                  }),
            )
       ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            dbHelper!
                .insert(
              NotesModel(
                title: 'Notes Model',
                age: 22,
                description: 'This is my first database app',
                email: 'zeeshanhabib5555@gmail.com',
              ),
            )
                .then(
                  (value) {
                print('Data added');
                setState(() {
                  notesList = dbHelper!.getNotesList();
                });
              },
            ).catchError((error) => print(error.toString()));
          },

          child: const Icon(Icons.add),
    ),
      ),
    );
  }
}
