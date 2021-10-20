import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:routine_reminder/database/repository.dart';

import 'package:routine_reminder/models/activities_type.dart';
import 'package:routine_reminder/models/task.dart';
import 'package:routine_reminder/notifications/notifications.dart';
import '../../helpers/platform_flat_button.dart';
import '../../screens/add_new_task/form_fields.dart';
import 'activity_type_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddNewActivity extends StatefulWidget {
  @override
  _AddNewActivityState createState() => _AddNewActivityState();
}

class _AddNewActivityState extends State<AddNewActivity> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

 final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  

  
  final List<String> weightValues = ["Work", "Fun","Need","Social"];

  //list of Activities
  final List<ActivityType> taskTypes = [
    ActivityType("Watching", Image.asset("assets/images/sunglasses.png"), true),
    ActivityType(
        "Celebrating", Image.asset("assets/images/celebration.png"), false),
    ActivityType(
        "Eating", Image.asset("assets/images/eating.png"), false),
    ActivityType(
        "Drinking", Image.asset("assets/images/drinking.png"), false),
    ActivityType(
        "Attending ", Image.asset("assets/images/attending.png"), false),
    ActivityType(
        "Traveling to", Image.asset("assets/images/travel.png"), false),
    ActivityType(
        "Listening to", Image.asset("assets/images/listening.png"), false),
    ActivityType(
        "Looking for", Image.asset("assets/images/looking.png"), false),
    ActivityType(
        "Thinking", Image.asset("assets/images/thinking.png"), false),
    ActivityType(
        "Reading", Image.asset("assets/images/reading.png"), false),
    ActivityType(
        "Playing", Image.asset("assets/images/playing.png"), false),
    ActivityType(
        "Supporting", Image.asset("assets/images/support.png"), false),  
  ];

  //-------------Task object------------------
  int howManyWeeks = 1;
  String? selectWeight;
  DateTime setDate = DateTime.now();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  //==========================================

  //-------------- Database and notifications ------------------
  final Repository _repository = Repository();
  final Notifications _notifications = Notifications();

  //============================================================

  @override
  void initState() {
    super.initState();
    selectWeight = weightValues[0];
    initNotifies();
  }

  //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - 60.0;

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: deviceHeight * 0.05,
                child: FittedBox(
                  child: InkWell(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0),
                height: deviceHeight * 0.05,
                child: FittedBox(
                    child: Text(
                  "Set Tasks",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.black),
                )),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Container(
                height: deviceHeight * 0.37,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FormFields(
                        howManyWeeks,
                        selectWeight!,
                        popUpMenuItemChanged,
                        sliderChanged,
                        titleController,
                        noteController)),
              ),
              Container(
                height: deviceHeight * 0.035,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: FittedBox(
                    child: Text(
                      "Activities",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 1.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Container(
                height: 100,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ...taskTypes.map(
                        (type) => ActivityTypeCard(type, ActivityTypeClick))
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Container(
                width: double.infinity,
                height: deviceHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: PlatformFlatButton(
                          handler: () => openTimePicker(),
                          buttonChild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Text(
                                DateFormat.Hm().format(this.setDate),
                                style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.access_time,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                          color: Color.fromRGBO(7, 190, 200, 0.1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: PlatformFlatButton(
                          handler: () => openDatePicker(),
                          buttonChild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              Text(
                                DateFormat("dd.MM").format(this.setDate),
                                style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.event,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                          color: Color.fromRGBO(7, 190, 200, 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: deviceHeight * 0.09,
                width: double.infinity,
                child: PlatformFlatButton(
                  handler: () async => saveTask(),
                  color: Theme.of(context).primaryColor,
                  buttonChild: Text(
                    "Done",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //slider changer
  void sliderChanged(double value) =>
      setState(() => this.howManyWeeks = value.round());

  //choose popum menu item
  void popUpMenuItemChanged(String value) =>
      setState(() => this.selectWeight = value);

  //------------------------OPEN TIME PICKER (SHOW)----------------------------
  //------------------------CHANGE CHOOSE TASK TIME----------------------------

  Future<void> openTimePicker() async {
    await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            helpText: "Choose Time")
        .then((value) {
      DateTime newDate = DateTime(
          setDate.year,
          setDate.month,
          setDate.day,
          value != null ? value.hour : setDate.hour,
          value != null ? value.minute : setDate.minute);
      setState(() => setDate = newDate);
      print(newDate.hour);
      print(newDate.minute);
    });
  }

  //====================================================================

  //-------------------------SHOW DATE PICKER AND CHANGE CURRENT CHOOSE DATE-------------------------------
  Future<void> openDatePicker() async {
    await showDatePicker(
            context: context,
            initialDate: setDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 100000)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setState(() => setDate = newDate);
      print(setDate.day);
      print(setDate.month);
      print(setDate.year);
    });
  }

  //=======================================================================================================

  //--------------------------------------SAVE TASK IN DATABASE---------------------------------------
  Future saveTask() async {
    
     if (titleController.text.isEmpty || noteController.text.isEmpty) {
     
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All Fields are Required'),
          ),
        );
    } else {
     
    //check if activity time is lower than actual time
    if (setDate.millisecondsSinceEpoch <=
        DateTime.now().millisecondsSinceEpoch) {
     // print("check your activity time and date");
     ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check your activity time and date'),
          ),
        );
    } else {
      //create task object
      Task task = Task(
          note: noteController.text,
          howManyWeeks: howManyWeeks,
          taskForm: taskTypes[taskTypes.indexWhere((element) => element.isChoose == true)].title,
          title: titleController.text,
          time: setDate.millisecondsSinceEpoch,
          type: selectWeight!,
          notifyId: Random().nextInt(10000000));

      //---------------------| Save as many tasks as many user checks |----------------------
      for (int i = 0; i < howManyWeeks; i++) {
        dynamic result =
            await _repository.insertData("Tasks", task.taskToMap());
        if (result == null) {
          //print("something wrong");
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something wrong'),
          ),
        );
        } else {
          //set the notification schneudele
          tz.initializeTimeZones();
          tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
          await _notifications.showNotification(task.title!, task.note! + " " + task.taskForm! + " " + task.type!, time,
              task.notifyId!,
              flutterLocalNotificationsPlugin!);
          setDate = setDate.add(Duration(milliseconds: 604800000));
          task.time = setDate.millisecondsSinceEpoch;
          task.notifyId = Random().nextInt(10000000);
        }
      }
      //---------------------------------------------------------------------------------------
     // print("Saved");
     ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved'),
          ),
        );
      Navigator.pop(context);
    }
  }
  }
  //=================================================================================================

  //----------------------------CLICK ON TASK FORM CONTAINER----------------------------------------
  void ActivityTypeClick(ActivityType activity) {
    setState(() {
      taskTypes.forEach((taskTypes) => taskTypes.isChoose = false);
      taskTypes[taskTypes.indexOf(activity)].isChoose = true;
    });
  }

  //=====================================================================================================

  //get time difference
  int get time =>
      setDate.millisecondsSinceEpoch -
      tz.TZDateTime.now(tz.local).millisecondsSinceEpoch;
}
