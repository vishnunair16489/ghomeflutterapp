import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/menu_icons.dart';
import 'package:ghomefinal/constant_values/rooms.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant_values/ipaddress.dart';
class NewRoom extends StatefulWidget {

  late double _height;
  final menuicon = menuicons;



  String file="assets/images/drawingroom.jpg";

    NewRoom({Key? key}) : super(key: key);
  @override
  _NewRoomState createState() => _NewRoomState();
}

class _NewRoomState extends State<NewRoom> {

  TextEditingController roomnamecontroller = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String dropdownValue = 'One';
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  final dropdownroommenu = rooms;
String host="";
  String? selectedValue;

  @override
  void initState() {
    super.initState();


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
  Future broadcast() async {
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      if(action==true) {
        host = ipaddressonline;
      } else
      {
        host= ipaddressoffline;
      }
    }
    );
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: host,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    String roomname="";
    if(roomnamecontroller.text.toString()==""||roomnamecontroller.text.toString().toUpperCase()=="NULL")
    {
      roomname=selectedValue.toString();
    }
    else
    {
      roomname=roomnamecontroller.text.toString();
    }

    DateTime date=DateTime.now();
    String finaldate="";
    var results = await conn.query("select now();");
    for (var row in results)
    {
      date = row[0] as DateTime;
      finaldate = date.toString().substring(0,10) + ' ' + date.toString().substring(11,23);
    }
     results = await conn.query("insert into ghomeroom(roomname,roomphoto,roomtype,timestamp)values('"+roomname+"','null','"+selectedValue.toString()+"','"+finaldate+"');");
    int? id=results.insertId;
    apicall("!!!" + id.toString() + "!!!ghomeroom!!!inserted");
    await conn.close();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    widget._height = MediaQuery
        .of(context)
        .size
        .height;


    return NeumorphicBackground(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: widget._height * 0.4,
            flexibleSpace:  FlexibleSpaceBar(

              background:  Image.asset(widget.file,  fit: BoxFit.cover, ),

            ),
          ),

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return  Material(color:Colors.transparent,child: Column(
                  children: [
                    const SizedBox(height: 30),

                    ListTile(
                      leading: NeumorphicIcon(
                        Icons.room_preferences, size: 25,
                        style:  NeumorphicStyle(     color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),
                      title: const Text(
                        "Select a Building Type",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),


                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),child:
                    Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.stadium(),
                        depth: 5,
                        intensity: 0.2,
                      ),
                      child: Container(width:  double.infinity,
                        child:   DropdownButtonFormField2(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Your Building type',
                            style: TextStyle(fontSize: 14),
                          ),
                          icon:  Icon(
                              Icons.arrow_drop_down,
                              color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: dropdownroommenu
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select any room';
                            }
                          },
                          onChanged: (value) {

                            selectedValue=value.toString();
                            setState(() {
                              switch (value)
                              {
                                case "BEDROOM":widget.file="assets/images/drawingroom.jpg";
                                break;
                                case "KITCHEN":widget.file="assets/images/room.jpg";
                                break;
                                case "DRAWING ROOM":widget.file="assets/images/home.jpg";
                                break;
                                case "STORE ROOM":widget.file="assets/images/color.jpg";
                                break;
                                case "GARAGE":widget.file="assets/images/favorites.jpg";
                                break;

                              }

                            });
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                        ),
                      ),
                    ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Neumorphic(
                        style: const NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.stadium(),
                          shape: NeumorphicShape.concave,
                          depth: -0.5,
                        ), child:  TextField(
                        controller: roomnamecontroller,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(

                            labelText: "Enter the Building name(Optional)",

                            prefixIcon: Icon(
                              Icons.connect_without_contact_rounded,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 15, ),
                            border: InputBorder.none,
                            filled: true),

                      ),
                      ),

                    ),
                    const SizedBox(height: 30),
                    NeumorphicButton(


                      onPressed: () {
                        broadcast();
                      },
                      child: const Text('SAVE'),
                    ),

                    const SizedBox(height: 20),
                  ],


                ),
                );
                  },
              childCount: 1,
            ),
          ),
        ],
      ),


    );
  }
}