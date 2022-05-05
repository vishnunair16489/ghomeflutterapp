import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/automation/automationinsert.dart';
import 'package:ghomefinal/newdevice/Newdevice.dart';
import 'package:ghomefinal/newdevice/newdeviceloadingpage.dart';
class Automation extends StatelessWidget {
  const Automation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: NeumorphicBackground(child: Container(
          height: double.infinity,

          child: const SafeArea(
              child:  AutomationInsert(),
          ),
        ),
        ),

      );
}
