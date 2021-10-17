import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:routine_reminder/models/task.dart';
import 'activity_card.dart';

class ActivityList extends StatelessWidget {
  final List<Task> listOfActivies;
  final Function setData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  ActivityList(this.listOfActivies,this.setData,this.flutterLocalNotificationsPlugin);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ActivityCard(listOfActivies[index],setData,flutterLocalNotificationsPlugin),
      itemCount: listOfActivies.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
