
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/all_accessory.dart';
import 'package:ghomefinal/homepagewidgets/fav_decive_template.dart';
import 'package:ghomefinal/models/roomdetails.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:ghomefinal/room/roomlayout.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';


class Display_Room_Tab extends StatefulWidget {


  const Display_Room_Tab({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return Display_Room_TabState();
  }
}

class Display_Room_TabState extends State<Display_Room_Tab> {


  late List<roomdetails> list = [];
  bool gotresult = false;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;

  @override
  void initState() {
    super.initState();
    broadcast();
  }


  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query('select * from ghomeroom;');
    for (var row in results) {
      roomdetails r1 = roomdetails();
      r1.id = row[0];
      r1.houseid = row[1];
      r1.roomid = row[2];
      r1.roomname = row[3];
      r1.roomphoto = row[4];
      r1.roomtype = row[5];


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
        child:Column(children: [
          const SizedBox(height: 20,),
          const Text('Rooms', textScaleFactor: 1.5,
              style: TextStyle(
                  fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
          const SizedBox(height: 20,),
          Column(


            children:  List.generate(
              list.length, (index) => Room_Layout(list[index]),
            ),
          ),
        ],)

      ),
    );
  }
}