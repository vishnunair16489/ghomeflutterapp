
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/no_accessory.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:ghomefinal/newdevice/btninfo.dart';
import 'package:provider/provider.dart';
import 'package:number_to_words/number_to_words.dart';
import '../constant_values/ipaddress.dart';
import 'device_info.dart';

class New_Device_Details_Init extends StatelessWidget {
  final String devicetype;
  final String noofswitches;
  const New_Device_Details_Init(this.devicetype, this.noofswitches,{Key? key}) : super(key: key);

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
          child: New_Device_Details(devicetype, noofswitches,),
        )

    );
  }
}

class New_Device_Details extends StatefulWidget {
  final String devicetype;
  final String noofswitches;
  late MQTTManager manager;
  New_Device_Details(this.devicetype, this.noofswitches,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return New_Device_DetailsState();
  }
}

class New_Device_DetailsState extends State<New_Device_Details> {
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  late final host;

  final message = "Select * from ghomedevice;";
  final topic = "mqttwrc";
  var rng = Random();
  late int code;
  late MQTTAppState currentAppState;

  bool value = true;
  bool result = false;
  bool newdevice = false;
  bool newdevicefound = false;
  bool newdeviceconfirmed = false;
  late String devicetype;
  late String noofswitches;
  late String switchnumber;
  late List<dynamic> list;
  List<bool> enabled = [false, false, false];

  @override
  void initState() {
    super.initState();
    host=ipaddressoffline;
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
    {
      code = rng.nextInt(900000) + 100000,
      widget.manager = MQTTManager(
          host: host,
          topic: topic,
          identifier: code.toString(),
          state: currentAppState),
      widget.manager.initializeMQTTClient(),
      widget.manager.connect(),
    });
  }


  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    if (value == true && currentAppState.getAppConnectionState ==
        MQTTAppConnectionState.connected) {
      try {
        //     manager.publish(message);
        value = false;
      }
      catch (error) {}
    }

    setState(() {


      if (currentAppState.getReceivedText.toString().contains("@@@") &&
          !currentAppState.getReceivedText.toString().contains("new") &&
          !currentAppState.getReceivedText.toString().contains("insert")) {

          newdevice = true;
          String splitvalue = currentAppState.getReceivedText.toString();
          devicetype = splitvalue.substring(3, 4);
          noofswitches = splitvalue.substring(4, 5);
          switchnumber = splitvalue.substring(5, 6);
          enabled.clear();
          List.generate(int.parse(noofswitches), (index) => enabled.add(false));
          enabled[int.parse(switchnumber) - 1] = true;

      }
    });



    final Container container = Container(child: design());

    return container;
  }


  Widget design() {
    return Material(child:NeumorphicBackground(child: SafeArea(child:Center(child: SingleChildScrollView(

      child: SizedBox(
        width: double.infinity,
        child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 Center(child:
                Text(
                    'Press the button to enter the name ', textScaleFactor: 1.2,
                    style: TextStyle(fontFamily: 'Montserrat'   ,  color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),
                ),),
                 const SizedBox(height: 10,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: newdevice == true ? [Btn_Info_Init(3)]
                        : [  Center(child:NeumorphicIcon(
                      Icons.sports_handball_sharp,
                      size:250,
                    ),),])


              ],
            ),
          ),

      ),
    ),
    ),
    ),
    ),
    );
  }
}

