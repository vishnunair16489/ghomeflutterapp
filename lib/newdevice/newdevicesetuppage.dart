import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:ghomefinal/newdevice/Newdevice.dart';
import 'package:provider/provider.dart';

class New_device_Setup_Page extends StatelessWidget {
  final String roomid;
   New_device_Setup_Page(this.roomid,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'GHome',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home:  ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: Setup(roomid: roomid),
        )

    );
  }
}

class Setup extends StatefulWidget {
  const Setup({Key? key, required this.roomid}) : super(key: key);
  final String roomid;

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {


  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(child:
    Container(
      child:  SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            body: Newdevice(widget.roomid),

          ),
        ),
      ),
    ),
    );
  }
}