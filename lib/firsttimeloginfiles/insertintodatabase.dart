import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mysql1/mysql1.dart';

import '../constant_values/ipaddress.dart';


class InsertIntoDatabase extends StatefulWidget {
  final String isuseronline,housetype,housename,isonline,userid;
  bool valueinit=true;

  String houseid="";


  InsertIntoDatabase( this.isuseronline,  this.housetype,  this.housename,  this.isonline, this.userid,{Key? key}) : super(key: key);
  @override
  _InsertIntoDatabaseState createState() => _InsertIntoDatabaseState();
}

class _InsertIntoDatabaseState extends State<InsertIntoDatabase> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));
    DateTime date=DateTime.now();
    String finaldate="";
    var results = await conn.query("select now();");
    for (var row in results)
    {
      date = row[0] as DateTime;
      finaldate = date.toString().substring(0,10) + ' ' + date.toString().substring(11,23);
    }
    String macid="";
     results = await conn.query( "select macid from ghomesettings;");
    for (var row in results) {
      macid=row[0].toString();
    }


    results = await conn.query("insert into ghomehouse(housename,photo,type,macid,timestamp)values('"+widget.housename+"','null','"+widget.housetype.toString()+"','"+macid+"','"+finaldate+"');");
    widget.houseid=results.insertId.toString();

    apicall("!!!" +widget.houseid+"!!!ghomehouse!!!inserted");
    apicall("!!!" + widget.userid.toString() + "!-"+widget.isuseronline+"!!!ghomeuser!!!inserted");
  await conn.close();

  }
  void apicall(String title) async {
    var clinet=http.Client();


    final response = await clinet.post(
      Uri.parse("http://"+ipaddressoffline+":8080/api"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'value':title,
      }),
    );


  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
    {
      broadcast(),
    });

  }
  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;


    return  Container(child:Column(
      mainAxisAlignment:MainAxisAlignment.start
      ,children: [
      CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(user!.photoURL.toString()),
      ),
      const SizedBox(height: 10,),
      Text(user!.displayName.toString()),
      const SizedBox(height: 30,),
      Text(widget.isuseronline+widget.housetype+widget.housename+widget.isonline+widget.userid),
      const Text("Sit back and relax till we do something in the background to make your experience hazardfree")
    ],),

    );
  }
}