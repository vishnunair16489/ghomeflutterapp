import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/housetype.dart';
import 'package:ghomefinal/constant_values/menu_icons.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';

import '../constant_values/ipaddress.dart';

typedef void housetypestringCallback(String val);
typedef void housenamestringCallback(String val);
typedef void isonlinestringCallback(String val);
bool valueinit=true;
class NewHouse extends StatefulWidget {

  late double _height;
  final menuicon = menuicons;
  String? selectedValue;

  String file="assets/images/drawingroom.jpg";

   final housetypestringCallback housetypestring;
   final housenamestringCallback housenamestring;
   final isonlinestringCallback isonlinestring;

  NewHouse({Key? key, required this.housetypestring, required this.housenamestring, required this.isonlinestring}) : super(key: key);
  @override
  _NewHouseState createState() => _NewHouseState();
}

class _NewHouseState extends State<NewHouse> {




  String dropdownValue = 'One';
  final dropdownroommenu = house;
  String? selectedValue;


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    widget._height = MediaQuery
        .of(context)
        .size
        .height;


    return  Column(
      children: [
        Image.asset(widget.file,height: widget._height*0.3 ,),

        const SizedBox(height: 30),

        ListTile(
          leading: NeumorphicIcon(
            Icons.room_preferences, size: 25,
            style:  NeumorphicStyle(     color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),
          title: const Text(
            "Select a Building Type",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),


        ),
        Padding(
          padding: const EdgeInsets.all(16.0),child:
        Neumorphic(
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.stadium(),
            depth: 5,
            intensity: 0.2,
          ),
          child: Container(width:  double.infinity,
            child:   DropdownButtonFormField2(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              isExpanded: true,
              hint: const Text(
                'Select Your Building type',
                style: TextStyle(fontSize: 14),
              ),
              icon:  Icon(
                  Icons.arrow_drop_down,
                  color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent
              ),
              iconSize: 30,
              buttonHeight: 60,
              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              items: dropdownroommenu
                  .map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select any room';
                }
              },
              onChanged: (value) {

                selectedValue=value.toString();
                widget.housetypestring(value.toString());
                setState(() {
                  switch (value)
                  {
                    case "HOUSE":widget.file="assets/images/drawingroom.jpg";
                    break;
                    case "OFFICE":widget.file="assets/images/room.jpg";
                    break;
                    case "FARMHOUSE":widget.file="assets/images/home.jpg";
                    break;
                    case "FLAT":widget.file="assets/images/color.jpg";
                    break;


                  }

                });
              },
              onSaved: (value) {
                selectedValue = value.toString();
                widget.housetypestring(value.toString());

              },
            ),
          ),
        ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Neumorphic(
            style: const NeumorphicStyle(
              boxShape: NeumorphicBoxShape.stadium(),
              shape: NeumorphicShape.concave,
              depth: -0.5,
            ), child:  TextField(
            onChanged: (text) {
              widget.housenamestring(text);
            },
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(

                labelText: "Enter the Building name(Optional)",

                prefixIcon: Icon(
                  Icons.connect_without_contact_rounded,
                ),
                labelStyle: TextStyle(
                  fontSize: 15, ),
                border: InputBorder.none,
                filled: true),

          ),
          ),

        ),
        const SizedBox(height: 20),
        CheckboxListTile(
          activeColor: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent ,
          secondary:  Icon(Icons.network_wifi,color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent ,),
          title: const Text('Connect online'),
          subtitle: const Text('Do you want yours  home to be controlled from anywhere in the world '),
          value: valueinit,
          onChanged: (value) {

            setState(() {

             valueinit = value as bool;
              if(value) {
                widget.isonlinestring("online");

              }
              else
              {
                widget.isonlinestring("offline");
              }
            });
          },
        ),



      ],





    );
  }
}