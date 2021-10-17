import 'package:flutter/material.dart';
import 'package:routine_reminder/models/activities_type.dart';


class ActivityTypeCard extends StatelessWidget {
  final ActivityType taskType;
  final Function handler;
  ActivityTypeCard(this.taskType,this.handler);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => handler(taskType),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            color: taskType.isChoose ? Color.fromRGBO(7, 190, 200, 1) :Colors.white,
            ),
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5.0,),
                Container(width:50,height: 50.0,child: taskType.image),
                SizedBox(height: 7.0,),
                Container(child: Text(taskType.title,style: TextStyle(
                  color:taskType.isChoose ? Colors.white : Colors.black,fontWeight: FontWeight.w500
                ),)),
              ],
            ),

          ),
        ),
        SizedBox(width: 15.0,)
      ],
    );
  }
}
