
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/aminationicons.dart';
import 'package:ghomefinal/constant_values/popup_window.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';


class Newdevice extends StatefulWidget {
  final String roomid;
  const Newdevice(this.roomid,{Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return NewdeviceState();
  }
}

class NewdeviceState extends State<Newdevice> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  late final host;

  final message = "Select * from ghomedevices;";
  final topic = "mqttwrc";
  var rng = Random();
  late double _height;
  late double _width;
  late MQTTAppState currentAppState;
  late MQTTManager manager;
  late int code;
  late String devicetype;
  late String noofswitches;
  bool newdevice = false;
  bool newdevicefound = false;
  bool newdeviceconfirmed = false;


  late List<dynamic> list;

  @override
  void initState() {
    super.initState();
    host=ipaddressoffline;
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
    setState(() {
      if (currentAppState.getReceivedText.toString().contains("@@@")) {
        setState(() {

          String splitvalue = currentAppState.getReceivedText.toString();
          devicetype = splitvalue.substring(3, 4);
          noofswitches =  splitvalue.substring(4, 5);
          newdevice = true;
          HapticFeedback.heavyImpact();

        });
      }

    });
    return    NeumorphicApp(
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
    home: Container(child:Material(child: design(widget.roomid)),),);


  }

  Widget design(String roomid) {
    return NeumorphicBackground(child:!newdevice ? Center(heightFactor: double.infinity,child:Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center ,children:[NeumorphicIcon(
         Icons.search,
         size:_height*0.5,
         style:const NeumorphicStyle(depth: 5),

    ),
       Text("Click on the button to activate the the discovery mode")],
        ),)

  /* Column(children:const [Animation_Icons("assets/images/btn.gif"),

      Text("hi there")],
    ),)
*/
  /*  Column(children:[Image.asset("assets/images/btn.gif"
    ),],),)*/

        : SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:   Popup_Window(devicetype, noofswitches,code,roomid)
          ),

      ),
    ),
    );
  }
}

