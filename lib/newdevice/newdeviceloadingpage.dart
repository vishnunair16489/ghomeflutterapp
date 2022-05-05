import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:ghomefinal/newdevice/Newdevice.dart';
import 'package:provider/provider.dart';

class NewDeviceLoadingPage extends StatelessWidget {
  const NewDeviceLoadingPage({Key? key}) : super(key: key);

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
          child:   Scaffold(
            body: NeumorphicBackground(child: Container(
              height: double.infinity,

              child: const SafeArea(
                  child:  Newdevice("NULL")
              ),
            ),
            ),

          ),
        ),

    );
  }
}
