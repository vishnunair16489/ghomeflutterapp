
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';



class AutomationInsert extends StatefulWidget {
  const AutomationInsert({Key? key}) : super(key: key);

  @override
  _AutomationInsertState createState() => _AutomationInsertState();
}

class _AutomationInsertState extends State<AutomationInsert> {
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  bool iosStyle = true;
  late DateTime _selectedDate;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(Duration(days: 5));
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: SafeArea(left: true, right: true, child: Neumorphic(child: Center(
          child: SingleChildScrollView(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            Neumorphic(
            padding:const EdgeInsets.all(15.0) ,
            margin: const EdgeInsets.all(10.0), style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,

          ),child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                const Text("Select Date and time from"),
                CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date!;
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _time,
                          onChange: onTimeChanged,
                          minuteInterval: MinuteInterval.FIVE,
                          // Optional onChange to receive value as DateTime
                          onChangeDateTime: (DateTime dateTime) {
                            print(dateTime);
                          },
                        ),
                      );
                    });
                  },
                  leftMargin: 20,
                  monthColor: Colors.white70,
                  dayColor: Colors.teal[200],
                  dayNameColor: Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: Color(0xFF333A47),
               //   selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en',
                ),
            ],),),

                SizedBox(height: 40),
                const Text("Select Date and time from"),
                CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date!;
                      Navigator.of(context).push(
                        showPicker(
                          context: context,
                          value: _time,
                          onChange: onTimeChanged,
                          minuteInterval: MinuteInterval.FIVE,
                          // Optional onChange to receive value as DateTime
                          onChangeDateTime: (DateTime dateTime) {
                            print(dateTime);
                            print(_selectedDate);
                          },
                        ),
                      );
                    });
                  },
                  leftMargin: 20,
                  monthColor: Colors.white70,
                  dayColor: Colors.teal[200],
                  dayNameColor: Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: Color(0xFF333A47),
                //  selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en',
                ),



                SizedBox(height: 10),
              ],

            ),
            ),
          ),
        ),
        ),


      );


}