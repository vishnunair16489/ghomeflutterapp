
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/models/deviestatus.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';
class Devicepopup_Touchthree_Init extends StatelessWidget {
  final int deviceid;
  final String devicename;
  const Devicepopup_Touchthree_Init(this.deviceid,this.devicename,{Key? key}) : super(key: key);

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
          child: Devicepopup_Touchthree(deviceid, devicename,),
        )

    );
  }
}
class Devicepopup_Touchthree extends StatefulWidget {
  final int deviceid;
  final String devicename;

  const Devicepopup_Touchthree(this.deviceid,this.devicename,{Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return Devicepopup_TouchthreeState();
  }
}

class Devicepopup_TouchthreeState extends State<Devicepopup_Touchthree> {

  final ipaddressoffline=offlineipaddress;
  bool value = true;
  bool gotresult = false;
  late final host ;
  final topic = "mqttwrc";
  var rng = Random();
  late int code;

  late MQTTAppState currentAppState;
  late MQTTManager manager;


  late List<devicestatus> list=[];


  @override
  void initState() {
    super.initState();
    host =ipaddressoffline;
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
    broadcast();
  }
  void dispose() {
    manager.disconnect();
  currentAppState.dispose();
   super.dispose();

  }

  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query( "Select * from ghomedevicestatus where deviceid='"+widget.deviceid.toString()+"';");
    for (var row in results) {
      devicestatus r1=devicestatus();
   //   r1.id=row[0];
      r1.status=row[1];
   //   r1.lastupdated=row[2];
  //    r1.deviceid=row[3];


      list.add(r1);

    }
    setState(() {
      gotresult=true;

    });


    // Update some data

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    setState(() {


      if (currentAppState.getReceivedText.toString().contains("@@@")&&gotresult) {

        String splitvalue = currentAppState.getReceivedText.toString();
        int state=int.parse(splitvalue.substring(8,9));
        int switchno=int.parse(splitvalue.substring(5,6));
        list[switchno-1].status=state;


      }
    });
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(12)),
        depth: 8,
      ),
      child: Center(

        child: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(child:
                Text(widget.devicename.toUpperCase(), textScaleFactor: 1.5,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black45,
                        fontWeight: FontWeight.bold)),),
                const SizedBox(height: 20,),
                Center(child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(12)),
                    depth: -8,
                  ), child:
                Column(


                  children: gotresult == true ? List.generate(
                      list.length, (index) =>
                      desigbutton(
                          list[index].btnaddress.toString(), list[index].status))
                      : [Center(child: NeumorphicText(
                    "Loading...",
                    style: const NeumorphicStyle(
                      depth: 4, //customize depth here
                      color: Colors.black45, //customize color here
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 18, //customize size here
                      // AND others usual text style properties (fontFamily, fontWeight, ...)
                    ),
                  ),),
                  ],
                ),


                ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }



  Widget desigbutton(String btnname,int? status)
  {
    return Padding( padding: const EdgeInsets.all(10.0),child:Column(children:[Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(btnname,style: const TextStyle(fontSize: 24,
        color: Colors.black45,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal),),
         Icon(Icons.lightbulb,color:status==1?Colors.green:Colors.red ,)
      ],
    ),const SizedBox(height: 20,),],),);
  }
}
