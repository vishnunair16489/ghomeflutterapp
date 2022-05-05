
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/constant_values/rooms.dart';
import 'package:ghomefinal/homepagewidgets/all_accessory2.dart';
import 'package:ghomefinal/models/devicedetails.dart';
import 'package:ghomefinal/models/roomdetails.dart';
import 'package:ghomefinal/newdevice/newdevicesetuppage.dart';
import 'package:ghomefinal/room/add_device_from_list.dart';
import 'package:mysql1/mysql1.dart';

import '../constant_values/ipaddress.dart';



class RoomDetails extends StatefulWidget {

  late double _height;
  late double _width;
final roomdetails roomdetailsinfo;
  String file="assets/images/drawingroom.jpg";

  RoomDetails(this.roomdetailsinfo,{Key? key}) : super(key: key);
  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {


  bool value = true;
  String dropdownValue = 'One';
  late List<devicedetails> list=[];
  final dropdownroommenu = rooms;
  bool gotresult = false;
  String? selectedValue;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;


  @override
  void initState() {
    super.initState();
    broadcast();

  }

  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query( "Select * from ghomedevice where  roomid=" + widget.roomdetailsinfo.id.toString() + ";");
    for (var row in results) {
      devicedetails r1=devicedetails();
      r1.id = row[0];
      r1.devicetype = row[1];
      r1.devicename = row[2];
      r1.address?.add(row[3]);
      r1.status?.add(row[4]);
      r1.buttontype?.add(row[5]);


      list.add(r1);
    }
    setState(() {
      gotresult=true;

    });


    // Update some data

    await conn.close();
  }


  @override
  Widget build(BuildContext context) {

    widget._height = MediaQuery
        .of(context)
        .size
        .height;
    widget._width = MediaQuery
        .of(context)
        .size
        .width;
    widget.file = "assets/images/drawingroom.jpg";
    selectedValue = value.toString();
    setState(() {
      switch (widget.roomdetailsinfo.roomtype) {
        case "BEDROOM":
          widget.file = "assets/images/drawingroom.jpg";
          break;
        case "KITCHEN":
          widget.file = "assets/images/room.jpg";
          break;
        case "DRAWING ROOM":
          widget.file = "assets/images/flat.png";
          break;
        case "STORE ROOM":widget.file="assets/images/guestroom.jpg";
          break;
        case "GARAGE":
          widget.file = "assets/images/favorites.jpg";
          break;
      }
    });

    return Container( child: Hero(tag: 'trial1-1' + widget.roomdetailsinfo.id.toString()+"1",
        child: NeumorphicBackground(child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: widget._height * 0.3,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                      widget.roomdetailsinfo.roomname.toString().toUpperCase(), style: const TextStyle(
                    fontFamily: 'Montserrat', )),
                  background: Image.asset(widget.file, fit: BoxFit.cover,   color: const Color(
                      0xff5a5a5a).withOpacity(1.0),colorBlendMode:BlendMode.softLight ,),

                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.devices),
                    tooltip: 'Add new Device',
                    onPressed: () {
    HapticFeedback.heavyImpact();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>    New_device_Setup_Page( widget.roomdetailsinfo.id.toString().toUpperCase()) ));},
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    tooltip: 'Add from list',
                    onPressed: () {   HapticFeedback.heavyImpact();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  Add_device_from_list() ));},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () {},
                  ),
                ],
              ),

              SliverList(

                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Material( child: Column(
                      children: [
                        const SizedBox(height: 30),

                        ListTile(

                          leading: NeumorphicIcon(
                              Icons.cast_connected_outlined, size: 25,
                              style:  NeumorphicStyle(
                                color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent),),
                          title: GestureDetector(onTap: () {
                            HapticFeedback.heavyImpact();
                            broadcast();
                          }, child: const Text(
                            "Devices Connected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),),


                        ),

                        SizedBox(
                          width: double.infinity,
                          child: Center(

                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      children: gotresult == true ? List.generate(
                                          list.length, (index) =>
                                          All_Accessory2(
                                              list[index]))
                                          : [Center(child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          boxShape: NeumorphicBoxShape
                                              .roundRect(
                                              BorderRadius.circular(12)),
                                          depth: -8,
                                        ),
                                        child: Container(
                                          width: 300,
                                          height: 100,
                                          child: Center(child: NeumorphicText(
                                            "Loading...",
                                            style: const NeumorphicStyle(
                                              depth: 4, //customize depth here
                                              color: Colors
                                                  .black45, //customize color here
                                            ),
                                            textStyle: NeumorphicTextStyle(
                                              fontSize: 18, //customize size here
                                              // AND others usual text style properties (fontFamily, fontWeight, ...)
                                            ),
                                          ),),),
                                      )),
                                      ],

                                    )


                                  ],
                                ),
                              ),
                            ),
                          ),

                      ],


                    ),


                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
    ),




    );
  }
}
