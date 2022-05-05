import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/device/devicestatus.dart';
import 'package:ghomefinal/device/devicetouchthree.dart';
import 'package:ghomefinal/models/devicedetails.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
class All_Accessory2  extends StatelessWidget {

  late double _height;
  late double _width;
  final devicedetails devicedetailsinfo;



  All_Accessory2(this.devicedetailsinfo,{Key? key}) : super(key: key);

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
    return
      Neumorphic(
        margin: const EdgeInsets.all(5.0), style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,
      ), child:
      SizedBox(
          height:90,
          width: _width * 0.40,
          child:

          GestureDetector(
            onLongPress: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  DeviceTouchThreeInit(devicedetailsinfo.id.toString()) ));
            },



            child: Container(
              height: _height * 0.5,
              width: _width * 0.7,

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:SingleChildScrollView(child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NeumorphicIcon( Icons.lightbulb_outline,size: 25,  style:  NeumorphicStyle(
                            color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),


                        Text(devicedetailsinfo.devicename.toString().length>10?devicedetailsinfo.devicename.toString().toString().toUpperCase().substring(0,10)+"...":devicedetailsinfo.devicename.toString().toUpperCase(), style: const TextStyle(fontSize: 12,decoration: TextDecoration.none, fontWeight: FontWeight.normal)),

                      ],
                    ),


                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(devicedetailsinfo.id.toString(),  style: const TextStyle(fontSize: 16,  decoration: TextDecoration.none, fontWeight: FontWeight.normal)),


                      ],
                    )
                  ],
                ),
                ),


              ),
            ),
          )

      ),


    );
  }
}