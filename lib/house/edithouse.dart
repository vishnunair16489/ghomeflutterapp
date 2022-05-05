import 'dart:math';

import 'package:alert/alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/camera/clickphoto.dart';
import 'package:ghomefinal/constant_values/housetype.dart';
import 'package:ghomefinal/constant_values/menu_icons.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';

class EditHouseInit extends StatelessWidget {

  const EditHouseInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return   ChangeNotifierProvider(
      create: (_) => MQTTAppState(),
      child:  EditHouse(),


    );
  }
}
class EditHouse extends StatefulWidget {

  late double _height;
  final menuicon = menuicons;


  String file="assets/images/drawingroom.jpg";

  EditHouse({Key? key}) : super(key: key);
  @override
  _EditHouseState createState() => _EditHouseState();
}

class _EditHouseState extends State<EditHouse> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  TextEditingController roomnamecontroller = TextEditingController();
 late final  String host ;
  final topic = "mqttwrc";
  var rng = Random();
  late MQTTAppState currentAppState;
  late MQTTManager manager;
  late int code;
  String dropdownValue = 'One';

  final dropdownroommenu = house;

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    host=ipaddressoffline;
    checkhouse();
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
    {
      code = rng.nextInt(900000) + 100000,
      manager = MQTTManager(
          host: host,
          topic: topic,
          identifier: code.toString(),
          state: currentAppState),
      manager.initializeMQTTClient(),
      manager.connect(),

    });

  }
  @override
  void dispose() {
    currentAppState.dispose();
    manager.disconnect();
    super.dispose();
  }
  Future checkhouse() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));


    var results = await conn.query( "select * from ghomehouse");
    if(results.isNotEmpty) {

      Alert(message: "Already Created. Cannot create another house in the same netwrok!", shortDuration: true).show();
      await conn.close();
      Navigator.pop(context);

    }
  }

  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table

    String housename="";
    if(roomnamecontroller.text.toString()==""||roomnamecontroller.text.toString().toUpperCase()=="NULL")
    {
      housename=selectedValue.toString();
    }
    else
    {
      housename=roomnamecontroller.text.toString();
    }
    String macid="";
    var results = await conn.query( "select macid from ghomesettings;");
    for (var row in results) {
      macid=row[0].toString();
    }


    results = await conn.query("insert into ghomehouse(housename,photo,type,macid)values('"+housename+"','null','"+selectedValue.toString()+"','"+macid+"');");
    manager.publish("!!!"+results.insertId.toString()+"!!!ghomehouse!!!inserted");
    setState(() {
      // gotresult=true;

    });


    // Update some data

    await conn.close();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
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

              background:  TakePictureScreen(),

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