

class NotesModel{       //Class Model

  final int? id;
  final int age;
  final String title;
  final String description;
  final String email;

  NotesModel({this.id, required this.title, required this.email, required this.age, required this.description});//constructor

  NotesModel.fromMap(Map<String, dynamic> res):   //Create Map  //res = resources
        id = res['id'],
        age = res['age'],
        title = res['title'],
        description = res['description'],
        email = res['email'];

  Map<String,Object?> toMap(){

    return{
      'id' : id,
      'age' : age,
      'title' : title,
      'description' : description,
      'email' : email,

    };
  }
}