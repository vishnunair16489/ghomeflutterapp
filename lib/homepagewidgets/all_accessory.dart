import 'dart:ui';

import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/device/devicetouchthree.dart';
import 'package:ghomefinal/models/devicedetails.dart';
class All_Accessory  extends StatelessWidget {

  late double _height;
  late double _width;
  final devicedetails devicedetailsinfo;

  All_Accessory(this.devicedetailsinfo, {Key? key}) : super(key: key);

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
      Hero(tag: 'idvalue1' + devicedetailsinfo.id.toString(),
      child: CupertinoContextMenu(child:
      Neumorphic(
        margin: const EdgeInsets.all(3.0), style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,

      ), child:
      SizedBox(
          height: 100,
          width: _width * 0.45,
          child:

          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  DeviceTouchThreeInit(devicedetailsinfo.id.toString())));

            },
            onLongPress: () {
              HapticFeedback.heavyImpact();
              Alert(message: 'Test', shortDuration: true).show();
            },


            child: Container(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NeumorphicIcon(Icons.lightbulb_outline, size: 25,  style:  NeumorphicStyle(
                    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),
                          ),


                   Text(devicedetailsinfo.devicename
                            .toString()
                            .length > 10
                            ? devicedetailsinfo.devicename.toString()
                            .toUpperCase()
                            .substring(0, 10) + "..."
                            : devicedetailsinfo.devicename.toString()
                            .toUpperCase(), style: const TextStyle(fontSize: 8,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal)),

                      ],
                    ),


                    const SizedBox(height: 25,),

    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(devicedetailsinfo.id.toString(),
                            style: const TextStyle(fontSize: 16,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,children:  List.generate(devicedetailsinfo.address!.length, (index) =>
                          design(devicedetailsinfo.buttontype![index].toString(),devicedetailsinfo.status![index].toString()),)
                    )
                  ],
                ),
                  ],
                  ),),


              ),
            ),
          )

      ),


      ),
        actions: [
          CupertinoContextMenuAction(
            child: Text("Edit"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            trailingIcon:CupertinoIcons.pen,
          ),

          CupertinoContextMenuAction(
            child: Text("Delete"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.delete,
          )
        ],

      ),

    );


  }
  Widget design( String type,String status) {

    if(type=="BLUB")
      {
     return Icon( Icons.power_settings_new,size: 15,
            color: status=="0"? Colors.red:Colors.green);
      }
    if(type=="FAN")
    {
      return Icon( Icons.desktop_windows,size: 15,
          color: status=="0"? Colors.red:Colors.green);
    }
    if(type=="DEVICE")
    {
      return   Icon( Icons.plumbing,size: 15,
          color: status=="0"? Colors.red:Colors.green);
    }
    return Container();


  }

}