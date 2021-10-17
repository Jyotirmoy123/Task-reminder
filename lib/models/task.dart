class Task {
  int? id;
  String? title;
  String? note;
  String? type;
  int? howManyWeeks;
  String? taskForm;
  int? time;
  int? notifyId;

  Task(
      {this.id,
      this.howManyWeeks,
      this.time,
      this.note,
      this.taskForm,
      this.title,
      this.type,
      this.notifyId});

  //------------------set task to map-------------------

  Map<String, dynamic> taskToMap() {
    Map<String, dynamic> map = Map();
    map['id'] = this.id;
    map['title'] = this.title;
    map['note'] = this.note;
    map['type'] = this.type;
    map['howManyWeeks'] = this.howManyWeeks;
    map['taskForm'] = this.taskForm;
    map['time'] = this.time;
    map['notifyId'] = this.notifyId;
    return map;
  }

  //=====================================================

  //---------------------create task object from map---------------------
  Task taskMapToObject(Map<String, dynamic> taskMap) {
    return Task(
        id: taskMap['id'],
        title: taskMap['title'],
        note: taskMap['note'],
        type: taskMap['type'],
        howManyWeeks: taskMap['howManyWeeks'],
        taskForm: taskMap['taskForm'],
        time: taskMap['time'],
        notifyId: taskMap['notifyId']);
  }
//=====================================================================


  //---------------------| Get the activity image path |-------------------------
  String get image{
    switch(this.taskForm){
      case "Watching": return "assets/images/sunglasses.png"; break;
      case "Celebrating":return "assets/images/celebration.png"; break;
      case "Eating":return "assets/images/eating.png"; break;
      case "Drinking":return "assets/images/drinking.png"; break;
      case "Attending":return "assets/images/attending.png"; break;
      case "Traveling to":return "assets/images/travel.png"; break;
      case "Listening to":return "assets/images/listening.png"; break;
      case "Looking for":return "assets/images/looking.png"; break;
      case "Thinking":return "assets/images/thinking.png"; break;
      case "Reading":return "assets/images/reading.png"; break;
      case "Playing":return "assets/images/playing.png"; break;
      case "Supporting":return "assets/images/support.png"; break;
      default : return "assets/images/attending.png"; break;
    }
  }
  //=============================================================================
}
