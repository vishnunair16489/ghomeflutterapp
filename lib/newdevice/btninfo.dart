
import 'dart:io' show Platform;
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/aminationicons.dart';
import 'package:ghomefinal/constant_values/animated_card_widget.dart';
import 'package:ghomefinal/constant_values/devicetype.dart';
import 'package:ghomefinal/constant_values/housetype.dart';
import 'package:ghomefinal/models/roomdetails.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';


class Btn_Info_Init extends StatelessWidget {
  final int deviceid;

  const Btn_Info_Init( this.deviceid, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GHome',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home:  ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: Btn_Info(deviceid),
        )

    );
  }
}
class Btn_Info extends StatefulWidget {

  final int deviceid;
  Btn_Info(this.deviceid,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Btn_InfoState();
  }
}

class Btn_InfoState extends State<Btn_Info> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  late final host ;
  final topic = "mqttwrc";
  var rng = Random();
  TextEditingController devicenamecontroller = TextEditingController();
  late MQTTAppState currentAppState;
  late MQTTManager manager;
  late String address;
  late String selectedValue;
  bool popup=false;


  final dropdowndevicetype = devicetype;

  @override
  void initState() {
    super.initState();
    host=ipaddressoffline;
    int code;
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
  Future broadcastmysqlselect() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));



    var results = await conn.query("select * from ghomebutton where deviceid='"+widget.deviceid.toString()+"' and buttonname='' limit 1;");
    for (var row in results) {
     address=row[2];

    }
    setState(() {
      // gotresult=true;

    });


    // Update some data

    await conn.close();
  }
  Future broadcastmysqlupdate() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));



    var results = await conn.query("update  ghomebutton set buttonname='"+devicenamecontroller.text+"' where buttonaddress='"+address+"';");
     results = await conn.query("update  ghomedevicestatus set buttontype='"+selectedValue+"' where address='"+address+"';");


    await conn.close();
  }

  void broadcast() {
    if (currentAppState.getAppConnectionState ==
        MQTTAppConnectionState.connected) {
      try {

        manager.publish("&&&A"+address+"*");
        broadcastmysqlupdate();
        //     manager.publish("insert into ghomedevice(devicetype,devicename,houseid )values('Touch','kitchen',1)");

      }
      catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;


    setState(() {
      if (currentAppState.getReceivedText.toString().contains("@@@") &&
          !currentAppState.getReceivedText.toString().contains("new") &&
          !currentAppState.getReceivedText.toString().contains("insert")) {
        String splitvalue = currentAppState.getReceivedText.toString();
        //   String   devicetype = splitvalue.substring(3, 4);
        //      String  noofswitches = splitvalue.substring(4, 5);
        //     String  switchnumber = splitvalue.substring(5, 6);
        broadcastmysqlselect();
        currentAppState.setReceivedText("");
        WidgetsBinding.instance?.addPostFrameCallback((_) =>
        {
         if(popup==false)
           {
             popup=true,
             design(),
           }
        });
      }
    });
    return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'Neumorphic App',
        themeMode: ThemeMode.system,

        theme: const NeumorphicThemeData(
          baseColor: Color(0xffffffff),
          lightSource: LightSource.topLeft,

          depth: 0.5,

        ),
        darkTheme: const NeumorphicThemeData(
          baseColor: Color(0xff333333),
          lightSource: LightSource.topLeft,

          depth: 0.5,

        ),

        home: Material(child: NeumorphicBackground(child: Center(
            child: (Container(child: Column(children: [
              Image.asset("assets/images/room.jpg"),
              Text(
                  "Please any button on the new found device to activate the address setting property")
            ])))))));
  }


  @override
  void dispose() {
    devicenamecontroller.dispose();
    super.dispose();
  }
  void design() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
  isDismissible: false,
      enableDrag: false,

      builder: (BuildContext context,) =>
          NeumorphicApp(
            debugShowCheckedModeBanner: false,
            title: 'Neumorphic App',
            themeMode: ThemeMode.system,

            theme: const NeumorphicThemeData(
              baseColor: Color(0xffffffff),
              lightSource: LightSource.topLeft,

              depth: 0.5,

            ),
            darkTheme: const NeumorphicThemeData(
              baseColor: Color(0xff333333),
              lightSource: LightSource.topLeft,

              depth: 0.5,

            ),
            home:
            Neumorphic(
              margin: const EdgeInsets.all(7.0),
              child:SingleChildScrollView(child: Material(color:Colors.transparent,child: Column(
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
                        items: dropdowndevicetype
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
                            return 'Please select any device';
                          }
                        },
                        onChanged: (value) {

                          selectedValue = value.toString();

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
                    child:   Neumorphic(
                      style: const NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.stadium(),
                        shape: NeumorphicShape.flat,
                        depth: -5,
                      ),
                      child:  TextField(
                        controller: devicenamecontroller,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: "Kitchen  All Lights",
                            labelText: "Enter the switch name (Optional)",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lightbulb_outline,
                              color: Colors.grey,),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Colors.grey),
                            border: InputBorder.none,
                            fillColor: Colors.black12,
                            filled: false),


                      ),
                    ),


                  ),
                  const SizedBox(height: 30),
                  NeumorphicButton(


                    onPressed: () {
                      popup=false;
                         Navigator.of(context).pop();
                      broadcast();
                    },
                    child: const Text('SAVE'),
                  ),

                  const SizedBox(height: 20),
                ],


              ),

              ),),
          ),
          ),


    );
  }
}