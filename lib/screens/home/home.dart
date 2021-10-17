import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../notifications/notifications.dart';
import '../../database/repository.dart';
import '../../models/task.dart';
import 'activity_list.dart';
import '../../screens/home/calendar.dart';
import '../../models/calendar_day_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //-------------------| Flutter notifications |-------------------
  final Notifications _notifications = Notifications();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  //===============================================================

  //--------------------| List of Tasks from database |----------------------
  List<Task> allListOfTasks = <Task>[];
  final Repository _repository = Repository();
  List<Task> dailyTasks = <Task>[];
  //=========================================================================

  //-----------------| Calendar days |------------------
  final CalendarDayModel _days = CalendarDayModel(dayLetter: '', dayNumber: null, isChecked: null, month: null, year: null);
  List<CalendarDayModel>? _daysList;
  //====================================================

  //handle last choose day index in calendar
  int _lastChooseDay = 0;

  @override
  void initState() {
    super.initState();
    initNotifies();
    setData();
    _daysList = _days.getCurrentDays();
  }

  //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin = await _notifications.initNotifies(context);


  //--------------------GET ALL DATA FROM DATABASE---------------------
  Future setData() async {
    allListOfTasks.clear();
    (await _repository.getAllData("Tasks"))!.forEach((taskMap) {
      allListOfTasks.add(Task().taskMapToObject(taskMap));
    });
    chooseDay(_daysList![_lastChooseDay]);
  }
  //===================================================================

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final Widget addButton = FloatingActionButton(
      elevation: 2.0,
      onPressed: () async {
        //refresh the tasks from database
        await Navigator.pushNamed(context, "/add_new_task")
            .then((_) => setData());
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 24.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      floatingActionButton: addButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                top: 0.0, left: 25.0, right: 25.0, bottom: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: deviceHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "All Tasks",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Colors.black),
                        ),
                        ShakeAnimatedWidget(
                          enabled: true,
                          duration: Duration(milliseconds: 2000),
                          curve: Curves.linear,
                          shakeAngle: Rotation.deg(z: 30),
                          child: Icon(
                            Icons.notifications_none,
                            size: 42.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Calendar(chooseDay,_daysList!),
                ),
                SizedBox(height: deviceHeight * 0.03),
                dailyTasks.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: WavyAnimatedTextKit(
                          textStyle: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          text: [
                            "Waiting..."
                          ],
                          isRepeatingAnimation: true,
                          speed: Duration(milliseconds: 150),
                        ),
                      )
                    : ActivityList(dailyTasks,setData,flutterLocalNotificationsPlugin!)
              ],
            ),
          ),
        ),
      ),
    );
  }


  //-------------------------| Click on the calendar day |-------------------------

  void chooseDay(CalendarDayModel clickedDay){
    setState(() {
      _lastChooseDay = _daysList!.indexOf(clickedDay);
      _daysList!.forEach((day) => day.isChecked = false );
      CalendarDayModel chooseDay = _daysList![_daysList!.indexOf(clickedDay)];
      chooseDay.isChecked = true;
      dailyTasks.clear();
      allListOfTasks.forEach((task) {
        DateTime taskDate = DateTime.fromMicrosecondsSinceEpoch(task.time! * 1000);
        if(chooseDay.dayNumber == taskDate.day && chooseDay.month == taskDate.month && chooseDay.year == taskDate.year){
          dailyTasks.add(task);
        }
      });
      dailyTasks.sort((task1,task2) => task1.time!.compareTo(task2.time!));
    });
  }

  //===============================================================================


}
