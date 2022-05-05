import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/models/roomdetails.dart';
import 'package:ghomefinal/room/roomdetails.dart';
import 'package:path/path.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
class Room_Layout  extends StatelessWidget {

  late double _height;
  late double _width;

 final roomdetails roomdetailsinfo;
  late  String file;
  Room_Layout(this.roomdetailsinfo,{Key? key}) : super(key: key);

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
    switch (roomdetailsinfo.roomtype)
    {
      case "BEDROOM":file="assets/images/drawingroom.jpg";
      break;
      case "KITCHEN":file="assets/images/room.jpg";
      break;
      case "DRAWING ROOM":file="assets/images/home.jpg";
      break;
      case "STORE ROOM":file="assets/images/guestroom.jpg";
      break;
      case "GARAGE":file="assets/images/favorites.jpg";
      break;
      default:file="assets/images/switchback.jpg";

    }
    return Hero(tag:'trial1-1'+roomdetailsinfo.id.toString()+"1",
      child:
      Neumorphic( margin:const EdgeInsets.all(5.0),  style: const NeumorphicStyle(
        shape: NeumorphicShape.concave,
      ), child:
      SizedBox(
          height:200,//90,
          width: _width *0.85,//* 0.40,
          child:

          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  RoomDetails(roomdetailsinfo) ));
            },


            child: Container(
              decoration:  BoxDecoration(
                image: DecorationImage(
                  filterQuality: FilterQuality.high,
                  colorFilter: ColorFilter.mode(Colors.black26, BlendMode.hardLight),
                  opacity: 0.7,
                  image: AssetImage(file.toString()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:SingleChildScrollView(child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NeumorphicIcon( Icons.bedroom_parent,size: 30,  style:  const NeumorphicStyle(
                            color: Colors.white),),


                        Text(roomdetailsinfo.roomname.toString().length>10?roomdetailsinfo.roomname.toString().toUpperCase().substring(0,10)+"...":roomdetailsinfo.roomname.toString().toUpperCase(), style: const TextStyle(fontSize: 12, decoration: TextDecoration.none, color: Colors.white,fontWeight: FontWeight.normal)),

                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(roomdetailsinfo.id.toString(),  style: const TextStyle(fontSize: 16, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
                        SleekCircularSlider(
                          min: 16,
                            max:35,
                            initialValue: 18,

                            appearance:  CircularSliderAppearance(size:120, customWidths: CustomSliderWidths(progressBarWidth: 10),spinnerMode: false,infoProperties: InfoProperties(mainLabelStyle : const TextStyle(color:Colors.white),bottomLabelText: "somthing",bottomLabelStyle : const TextStyle(color:Colors.white,fontSize: 8),topLabelStyle : const TextStyle(color:Colors.white,fontSize: 10),topLabelText: "anything",modifier:(percentage) => "${percentage.ceil().toInt()}°C",),),
                            onChange: (double value) {
                              print(value);
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        NeumorphicIcon( Icons.light,size: 15,  style:  const NeumorphicStyle(
                            color: Colors.white),),
                        //    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),
                        NeumorphicIcon( Icons.ac_unit,size: 15,  style:  const NeumorphicStyle(
                            color: Colors.white),),
                        NeumorphicIcon( Icons.house_siding,size: 15,  style:  const NeumorphicStyle(
                            color: Colors.white),),
                        NeumorphicIcon( Icons.print,size: 15,  style:  const NeumorphicStyle(
                            color: Colors.white),),
                        NeumorphicIcon( Icons.radio,size: 15,  style:  const NeumorphicStyle(
                            color: Colors.white),),
                      ],
                    )
                  ],
                ),
                ),


              ),
            ),
          )

      ),


      ),
    );
  }
}