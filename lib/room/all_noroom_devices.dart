import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/device/devicetouchthree.dart';
import 'package:ghomefinal/models/devicedetails.dart';
class All_NoRoom_devices extends StatefulWidget {


  final devicedetails devicedetailsinfo;

  bool selected=false;
  All_NoRoom_devices(this.devicedetailsinfo,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return All_NoRoom_devicesState();
  }
}
class All_NoRoom_devicesState extends State<All_NoRoom_devices> {
  late double _height;
  late double _width;

  @override
  void initState() {
    super.initState();
  }
    @override
    Widget build(BuildContext context) {

      final Container   container =Container(child: design());

      return container;
    }
    Widget design() {

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
        margin: const EdgeInsets.all(7.0), style:  NeumorphicStyle(
        shape: widget.selected==false?NeumorphicShape.concave:NeumorphicShape.flat,
        depth :widget.selected==true?-0.5:0.5,
      ), child:
      SizedBox(
          height:90,
          width: _width * 0.40,
          child:

          GestureDetector(
            onLongPress: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  DeviceTouchThree(widget.devicedetailsinfo.id.toString()) ));
            },

            onTap: () {
              HapticFeedback.heavyImpact();
setState(() {
  widget.selected=!widget.selected;
});
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
                        NeumorphicIcon( Icons.lightbulb_outline,size: 25,   style:  NeumorphicStyle(
                            color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),


                        Text(widget.devicedetailsinfo.devicename.toString().length>10?widget.devicedetailsinfo.devicename.toString().toUpperCase().substring(0,10)+"...":widget.devicedetailsinfo.devicename.toString().toUpperCase(), style: const TextStyle(fontSize: 12, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),

                      ],
                    ),


                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.devicedetailsinfo.id.toString(),  style: const TextStyle(fontSize: 16,  decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
                       widget.selected==true? NeumorphicIcon( Icons.check_box,size: 25,   style: const NeumorphicStyle(color: Colors.green)):  Container(),
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