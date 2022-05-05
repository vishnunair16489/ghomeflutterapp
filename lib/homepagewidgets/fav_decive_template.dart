
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/room/newroom.dart';
class Fav_Device_Template  extends StatelessWidget {
  late double _height;
  late double _width;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    return SizedBox(

      child: Padding(padding: const EdgeInsets.all(10.0),
          child:
          Neumorphic(
            margin: const EdgeInsets.all(7.0), style: const NeumorphicStyle(
            shape: NeumorphicShape.flat,
            depth :-5,
            boxShape: NeumorphicBoxShape.circle(),
          ), child:
          SizedBox(
            height:60,
            width: 60,
            child:

            GestureDetector(
              onLongPress: () {

              },


              child: Container(
                height: _height * 0.5,
                width: _width * 0.7,

                child: GestureDetector(child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NeumorphicIcon( Icons.home,size: 25,
                        style:  NeumorphicStyle(
                        color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),

                ),   onTap: () {
    HapticFeedback.heavyImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>   NewRoom() ));}
                ),
              ),
            ),
          ),
          ),


        ),


    );
  }
}