
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/models/roomdetails.dart';
import 'package:ghomefinal/room/roomlayout.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant_values/ipaddress.dart';


class Display_Room extends StatefulWidget {


  const Display_Room({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return Display_RoomState();
  }
}

class Display_RoomState extends State<Display_Room> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<roomdetails> list = [];
  bool gotresult = false;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  late final host;

  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      if(action==true) {
        host = ipaddressonline;
      } else
      { host=ipaddressoffline;

      }
    }
    );
     broadcast();

  }
  @override
  void initState() {
    super.initState();
    getvalue();
  }


  Future broadcast() async {

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host:ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query('select * from ghomeroom;');
    for (var row in results) {
      roomdetails r1 = roomdetails();
      r1.id = row[0];
      r1.roomname = row[1];
      r1.roomphoto = row[2];
      r1.roomtype = row[3];


      list.add(r1);
    }
    setState(() {
      gotresult = true;
    });


    // Update some data

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    final Container container = Container(child: design(),
    );

    return container;
  }


  Widget design() {
    return Center(

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: List.generate(list.length, (index) {



            return   Room_Layout(list[index]);

          }),
        ),
      ),
    );
  }
}
