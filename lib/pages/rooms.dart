import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/appbar/appbar.dart';
import 'package:ghomefinal/room/displayroom.dart';
import 'package:ghomefinal/room/displayroomtab.dart';
import 'package:ghomefinal/room/newroom.dart';
class Rooms extends StatelessWidget {


  const Rooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(

        body: Neumorphic(
          style: const NeumorphicStyle(
            shape: NeumorphicShape.flat,
            depth: 5,
          ), child:  SizedBox(
          height: double.infinity,
          width: double.infinity, child: SingleChildScrollView(

          child: SafeArea(
            minimum: EdgeInsets.all(15.0),

            maintainBottomViewPadding: true,
            top: true,
            left: true,
            bottom: true,
            right: true,
            child: ClipRect(
              child: Container(child:
              const Display_Room_Tab(),),
              ),
            ),


        ),
        ),
        ),

      );

}
