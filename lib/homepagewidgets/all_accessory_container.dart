
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/all_accessory.dart';
import 'package:ghomefinal/models/devicedetails.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant_values/ipaddress.dart';
import 'no_accessory.dart';
class All_Accessory_ContainerInit extends StatelessWidget {

  const All_Accessory_ContainerInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return   ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: const All_Accessory_Container(),


    );
  }
}
class All_Accessory_Container extends StatefulWidget {

  const All_Accessory_Container({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return All_Accessory_ContainerState();
  }
}

class All_Accessory_ContainerState extends State<All_Accessory_Container> {

  bool value = true;
  bool gotresult = false;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
 late  String host ;
  final topic = "mqttwrc";
  var rng = Random();
  late int code;
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late List<devicedetails> list=[];
  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      if(action==true) {
        host =ipaddressonline;
      } else
      {
        host= ipaddressoffline;
      }
    }
    );
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
  @override
  void initState() {
    super.initState();
    host=  ipaddressoffline;
     getvalue();



  }
  @override
  void dispose() {
    manager.disconnect();
    currentAppState.dispose();
    super.dispose();
  }

  Future broadcast() async {


    final conn = await MySqlConnection.connect(ConnectionSettings(
        host:host,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query( "select id,devicetype,devicename,address,status,buttontype from ghomedevice right join ghomedevicestatus on ghomedevice.id=ghomedevicestatus.deviceid order by ghomedevice.id;");
    for (var row in results) {
      devicedetails r1=devicedetails();
      if(list.isEmpty) {
        r1.id = row[0];
        r1.devicetype = row[1];
        r1.devicename = row[2];
        r1.address=[];
        r1.status=[];
        r1.buttontype=[];
        r1.address?.add(row[3]);
        r1.status?.add(row[4]);
        r1.buttontype?.add(row[5]);
        list.add(r1);
      }
      else
        {
          bool flag=false;
          for(int i=0 ; i<=list.length-1;i++){

            if( list[i].id==row[0])
              {
                flag=true;
                list[i].address?.add(row[3]);
                list[i].status?.add(row[4]);
                list[i].buttontype?.add(row[5]);
                break;
              }
          }
          if(flag==false)
          {
            r1.id = row[0];
            r1.devicetype = row[1];
            r1.devicename = row[2];
            r1.address=[];
            r1.status=[];
            r1.buttontype=[];
            r1.address?.add(row[3]);
            r1.status?.add(row[4]);
            r1.buttontype?.add(row[5]);
            list.add(r1);
          }
        }




    }
    setState(() {
      gotresult=true;

    });


    // Update some data

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {

    final MQTTAppState appState = Provider.of<MQTTAppState>(context,listen: true);
    // Keep a reference to the app state.
    currentAppState = appState;
      if (currentAppState.getReceivedText.toString().contains("@@@")) {
        String splitvalue = currentAppState.getReceivedText.toString();
        int state = int.parse(splitvalue.substring(8, 9));
        int switchno = int.parse(splitvalue.substring(5, 8));
      //    list=[];
        for(int i=0;i<=list.length-1;i++)
          {
            for(int j=0;j<=list[i].address!.length-1;j++)
              {
                    if(list[i].address![j]==switchno)
                      {
                        list[i].status![j]=state;
                      }
              }
          }

          currentAppState.setReceivedText("text");

      }

    final Container container = Container(child: design());

    return container;
  }



  Widget design() {
    return Center(

      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Accessories', textScaleFactor: 1.3,
                  style: TextStyle(
                    fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),

              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: gotresult == true ? List.generate(list.length, (index) =>
                    All_Accessory(list[index]))
                    : [Center(child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(12)),
                    depth: -8,
                  ),
                  child: Container(

                    width: 300,
                    height: 100,
                    child: Center(child: NeumorphicText(
                      "Loading...",
                      style: const NeumorphicStyle(
                        depth: 4, //customize depth here
                        color: Colors.black45, //customize color here
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 18, //customize size here
                        // AND others usual text style properties (fontFamily, fontWeight, ...)
                      ),
                    ),),),
                )),
                ],)


            ],
          ),
        ),


    );
  }
}
