import 'package:alert/alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/housetype.dart';
import 'package:ghomefinal/constant_values/menu_icons.dart';
import 'package:ghomefinal/constant_values/rooms.dart';
import 'package:ghomefinal/constant_values/userlist.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant_values/ipaddress.dart';

class NewUser extends StatefulWidget {

  late double _height;


  String file="assets/images/drawingroom.jpg";

  NewUser({Key? key}) : super(key: key);
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController roomnamecontroller = TextEditingController();
  late Future<int> _counter;
  String dropdownValue = 'One';
  bool enabled=true;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;

  final dropdownuserlist = UserList;

  String? selectedValue;
  Future<void> setvalue(String id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('username', id);


  }
  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final String? action = prefs.getString('username');

    Alert(message: action.toString(), shortDuration: true).show();

  }

  @override
  void initState() {
    super.initState();
    broadcastselect();
    getvalue();

  }

  Future broadcast() async {

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table

    String housename = "";
    if (roomnamecontroller.text.toString() == "" ||
        roomnamecontroller.text.toString().toUpperCase() == "NULL") {
      housename = selectedValue.toString();
    }
    else {
      housename = roomnamecontroller.text.toString();
    }
    late Results results;
    String date="";

    results = await conn.query("select now();");
    for (var row in results)
      {
        date = row[0];
      }
    if (!enabled) {

      results = await conn.query(
          "insert into ghomeuser(name,role,approved,timestamp)values('" + housename +
              "','ADMIN','true','"+date+"');");
    }
    else {
      results = await conn.query(
          "insert into ghomeuser(name,role,approved,timestamp)values('" + housename + "','" +
              selectedValue.toString() + "','false','"+date+"');");
    }
    int? id = results.insertId;
    results = await conn.query("select * from ghomesettings");
    for (var row in results) {
      {
        String macid = row[1];
        macid = macid + "!" + id.toString();
        setvalue(macid.toString());
      }


      await conn.close();
      Navigator.pop(context);
    }
  }

  Future broadcastselect() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    var results = await conn.query("select * from ghomeuser");
    if(results.isEmpty)
      {
        Alert(message: "No user found. Adding you as the admin..!!!", shortDuration: true).show();
        setState(() {
          enabled=false;
        });
      }



    // Update some data

    await conn.close();
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
                return Material(color:Colors.transparent,child: Column(
                  children: [
                    const SizedBox(height: 30),

                    ListTile(
                      leading: NeumorphicIcon(
                        Icons.people, size: 25,
                        style:  NeumorphicStyle(     color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),
                      title: const Text(
                        "Select User Type",
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
                            'Select type',
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
                          items: dropdownuserlist
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                enabled: enabled,
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
                              return 'Please select any user type';
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

                            labelText: "Enter the user name",

                            prefixIcon: Icon(
                              Icons.person_add,
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