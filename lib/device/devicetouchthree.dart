import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/animated_card_widget.dart';
import 'package:ghomefinal/models/deviestatus.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant_values/ipaddress.dart';

class DeviceTouchThreeInit extends StatelessWidget {
  final String id;
  const DeviceTouchThreeInit(this.id,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'GHome',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home:  ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: DeviceTouchThree(id),
        )

    );
  }
}

class DeviceTouchThree extends StatefulWidget {
  final String id;
  late double _height;
  DeviceTouchThree(this.id,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DeviceTouchThreeState();
  }
}


class DeviceTouchThreeState extends State<DeviceTouchThree> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 late final host ;
  final topic = "mqttwrc";
  var rng = Random();
  late int code;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  late MQTTAppState currentAppState;
  late MQTTManager manager;
  late List<devicestatus> list=[];
  bool result=true;
  bool value=false;
  bool gotresult = false;
  int buttonnextid=0;
  Future<void> getvalue() async {
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

    });   broadcastdatabase();

  }
  @override
  void initState() {
    super.initState();

    getvalue();


  }
  void broadcast(int? index) {
    setState(() {

      if (currentAppState.getAppConnectionState ==
          MQTTAppConnectionState.connected) {
        try {
          if (list[int.parse(index.toString())-1].status==1) {
            manager.publish(":::F"+list[int.parse(index.toString())-1].btnaddress.toString()+"*:");
            list[int.parse(index.toString())-1].status=0;
            broadcastdatabaseupdate(list[int.parse(index.toString())-1].btnaddress.toString(),0);

          } else {
            manager.publish(":::N"+list[int.parse(index.toString())-1].btnaddress.toString()+"*:");
            list[int.parse(index.toString())-1].status=1;
            broadcastdatabaseupdate(list[int.parse(index.toString())-1].btnaddress.toString(),1);

          }
          //   manager.publish("insert into ghomedevice(devicetype,devicename,houseid )values('Touch','kitchen',1)");

        }
        catch (error) {}
      }
    });
  }
  Future broadcastdatabase() async {


    final conn = await MySqlConnection.connect(ConnectionSettings(
        host:host,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    var results = await conn.query( "Select ghomebutton.buttonname,ghomebutton.buttonaddress,ghomedevicestatus.status from ghomebutton,ghomedevicestatus where ghomebutton.buttonaddress=ghomedevicestatus.address and ghomedevicestatus.deviceid='"+widget.id.toString()+"';");
    for (var row in results) {
      devicestatus r1=devicestatus();
      r1.btnname=row[0];
      r1.btnaddress=row[1];
      r1.status=row[2];



      list.add(r1);

    }
    setState(() {
      gotresult=true;

    });


    // Update some data

    await conn.close();
  }
  Future broadcastdatabaseupdate(String address,int status) async {
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      if(action==true) {
        host = ipaddressonline;
      } else
      {
        host= ipaddressonline;
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


    var results = await conn.query( "update ghomedevicestatus set status='"+status.toString()+"' where address='"+address+"' ;");

    await conn.close();
  }
  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    setState(() {
      if (currentAppState.getReceivedText.toString().contains("@@@") &&
          gotresult) {
        String splitvalue = currentAppState.getReceivedText.toString();
        int state = int.parse(splitvalue.substring(8, 9));
        int switchno = int.parse(splitvalue.substring(5, 6));
        list[switchno - 1].status = state;
      }
    });

    widget._height = MediaQuery
        .of(context)
        .size
        .height;
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
      home: Container(child: design()),
    );


  }
  Widget design() {
    return Hero(tag: 'idvalue1' + widget.id.toString(), child: Material(

      child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
             leading:   IconButton(
                 icon: const Icon(Icons.devices),
                 tooltip: 'Add new Device',
                 onPressed: () {
                   HapticFeedback.heavyImpact();}
             ) ,
              expandedHeight: widget._height*0.5,
              flexibleSpace:  FlexibleSpaceBar(
                title: const Text('Master BedRoom'),
                background: AnimatedCardWidget() ,

              ),
          actions: <Widget>[
      IconButton(
      icon: const Icon(Icons.devices),
      tooltip: 'Add new Device',
      onPressed: () {
        HapticFeedback.heavyImpact();}
        )],
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 0,
                child: Center(
                  child: Text(''),
                ),
              ),
            ),
            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return  Column( children: [     SizedBox(height: widget._height*0.1,), Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children:  [Row(


                      children: gotresult == true ? List.generate(
                          list.length, (index) =>
                      designswitch( list[index].btnname.toString(), list[index].status,index+1))
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
                      ],
                  ),
                  ],

                  );

                },
                childCount:1,
              ),
            ),
          ],
        ),


      ),



    );
  }
  Widget designswitch(String btnname,int? status,int? index) {
    return Center(  child:Padding(
        padding: const EdgeInsets.all(10.0),

        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [   RotatedBox(
              quarterTurns: 1,
              child: NeumorphicSwitch(
                style: NeumorphicSwitchStyle(activeTrackColor: Colors.green),
                curve: Neumorphic.DEFAULT_CURVE,
                height: 75,
                value: status==1?true:false,
                isEnabled: true,
                onChanged: (bool state) {
                  setState(() {
                    broadcast(index);
                  });
                },
              )
          ),
          SizedBox(height: 20),
           Text(
            btnname,
            style: const TextStyle(
                fontSize: 15,fontWeight: FontWeight.bold),
          ),

        ],

      ),
    ),

    );

  }
}