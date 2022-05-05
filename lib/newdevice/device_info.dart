
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';

class Device_Info extends StatefulWidget {

  late int code;
  final bool id;
  final String switchnumber;
  Device_Info(this.id,this.code, this.switchnumber,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Device_InfoState();
  }
}

class Device_InfoState extends State<Device_Info> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
 late final host;

  final topic ="mqttwrc";
  var rng = Random();

  late MQTTAppState currentAppState;
  late MQTTManager manager;
  late double _height;
  late double _width;
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    host=ipaddressoffline;
    WidgetsBinding.instance?.addPostFrameCallback((_) =>  {
      widget.code = rng.nextInt(900000) + 100000,
      manager = MQTTManager(
          host: host,
          topic: topic,
          identifier: widget.code.toString(),
          state: currentAppState),
     manager.initializeMQTTClient(),
     manager.connect(),
    });

  }

  void broadcast()
  {

    if ( currentAppState.getAppConnectionState ==
        MQTTAppConnectionState.connected) {
      try {
        manager.publish("&&&A101*");
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
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;



    final Container   container =Container(child: design());

    return container;
  }


  Widget design() {

    return   Center(  child: Neumorphic( margin:const EdgeInsets.all(5.0),  style:  NeumorphicStyle(
      shape: NeumorphicShape.concave,
      depth: widget.id == false ? -2 : 0.5,
    ),
      child: AnimatedContainer(
        width: widget.id ? _width * 1.0 : _width * 0.85,

        alignment: Alignment.center,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child:
        Column(
          children: [
            ListTile(
              leading:      NeumorphicIcon( Icons.settings_power,size: 25,  style:  NeumorphicStyle(color:widget.id == true ? Colors.green: Colors.black54,)),
              title: Text(
                "Switch "+widget.switchnumber,
                  style:  TextStyle(color:widget.id == true ?(NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent): (NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.background: NeumorphicColors.darkBackground),fontWeight:widget.id == true ? FontWeight.bold:FontWeight.normal
                  ),
              ),


            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child:  Neumorphic(
                style: const NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.stadium(),
                  shape: NeumorphicShape.flat,
                  depth: -2,
                ),child: TextField(
                focusNode: myFocusNode,
                autofocus: widget.id,
                enabled: widget.id,

                keyboardType: TextInputType.name,
                decoration:  InputDecoration(

                    labelText: "Enter the name for the device",

                    prefixIcon:  Icon(
                      Icons.connect_without_contact_rounded,color:widget.id == true ?(NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent): (NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.background: NeumorphicColors.darkBackground),),
                  labelStyle:  TextStyle(color:widget.id == true ?(NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent): (NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.background: NeumorphicColors.darkBackground),),
                      border: InputBorder.none,

                    filled: true),

              ),
            ),

            ),
            const SizedBox(height: 10),
            NeumorphicButton(


              onPressed: () {
                widget.id?
             broadcast():null;
              },
              child:   Text('SAVE',   style:  TextStyle(color:widget.id == true ?(!NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent): (NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.background: NeumorphicColors.darkBackground),fontWeight:widget.id == true ? FontWeight.bold:FontWeight.normal),
            ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

    ),
    );
  }
}