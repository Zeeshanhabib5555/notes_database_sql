class Note {
  int? _id;
  var _title;
  var _description;
  var _date;
  var _priority;

  Note(this._title, this._date, this._priority, this._description);

  Note.withId(
      this._id, this._title, this._date, this._priority, this._description);

  int? get id => _id;

  String get title => _title!;

  String get description => _description!;

  int get priority => _priority!;

  String get date => _date!;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
// class Note {
//   int? _id;
//   var _description;
//   var _title;
//   var _date;
//   int _priority;
//
//   Note(this._title, this._date, this._priority, this._description);
//
//   Note.withId(
//       this._id, this._title, this._date, this._priority, this._description);
//
//   int? get id => _id;
//
//   int get priority => _priority;
//
//   String get description => _description!;
//
//   String get title => _title!;
//
//   String get date => _date!;
//
//   set title(String newTitle) {
//     if (newTitle.length <= 255) {
//       _title = newTitle;
//     }
//   }
//
//   set description(String newDescription) {
//     if (newDescription.length <= 255) {
//       _description = newDescription;
//     }
//   }
//
//   set priority(int newPriority) {
//     if (newPriority >= 1 && newPriority <= 2) {
//       _priority = priority;
//     }
//   }
//
//   set date(String newDate) {
//     _date = newDate;
//   }
//
//   //Convert a Note object to Map Object
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = {
//       'title': _title,
//       'priority': _priority,
//       'description': _description,
//       'date': _date,
//     };
//     if (id != null) {
//       map['id'] = _id;
//     }
//
//     return map;
//   }
//
//   // Map<String, dynamic> toMap() =>
//   //     {
//   //       if (id != null)
//   //         {
//   //           'id': _id;
//   //         },
//   //       'title': _title,
//   //       'priority': _priority,
//   //       'description': _description,
//   //       'date': _date,
//   //     };
//
// //Extract a Note object from Map Object
//   Note.fromObject(Map<String, dynamic> map) {
//     _title = map['_title'];
//     _priority = map['_priority'];
//     _description = map['_description'];
//     _date = map['_date'];
//     _id = map['id'];
//   }
// }
