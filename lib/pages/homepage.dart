import 'package:flutter/material.dart';
import 'package:ghomefinal/room/displayroom.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appbar/appbar.dart';

class HomePagelayout extends StatefulWidget {


  double height;
  HomePagelayout(this.height, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomePagelayoutState();
  }
}
class HomePagelayoutState extends State<HomePagelayout> {

  String role="";
  String approved="";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: widget.height * 0.5,
      child: Stack(children: [
        Image(image: AssetImage("assets/images/house.jpg"), width: MediaQuery
            .of(context)
            .size
            .width, height: widget.height * 0.4, fit: BoxFit.cover),
        SafeArea(child: Appbar(role)),

        const Positioned(top: 0.0,
            right: 0.0,
            bottom: -250.0 ,
            left: 0.0,
            child: Display_Room()),
      ],
      ),

    );
  }


  @override
  void initState() {
    super.initState();

    getvalue();
  }

  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final String? action = prefs.getString('username');
    List<String> id=action!.split('!');
    broadcast(id[1]);
  }
  Future broadcast(String id) async {
    String host="";
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      if(action==true) {
        host = "3.88.219.48";
      } else
      {
        host= '192.168.74.66';
      }
    }
    );
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query( "select * from ghomeuser where id='"+id+"'");
    for (var row in results) {
      setState(() {role=row[5];
      approved=row[6];

      });

    }


    await conn.close();
  }

}
