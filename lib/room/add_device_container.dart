
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/all_accessory.dart';
import 'package:ghomefinal/models/devicedetails.dart';
import 'package:ghomefinal/mqtt/MQTTManager.dart';
import 'package:ghomefinal/mqtt/state/MQTTAppState.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

import '../constant_values/ipaddress.dart';
import 'all_noroom_devices.dart';


class Add_Device_Container extends StatefulWidget {


  late double _height;
  int count=0;
   Add_Device_Container({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return Add_Device_ContainerState();
  }
}

class Add_Device_ContainerState extends State<Add_Device_Container> {

  bool gotresult = false;
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;

  late List<devicedetails> list=[];

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


    var results = await conn.query( "Select * from ghomedevice where roomid is  NULL;");
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




    final Container container = Container(child: design());

    return container;
  }


  Widget design() {
    widget._height = MediaQuery
        .of(context)
        .size
        .height;
    return Material(child:NeumorphicBackground(child:CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey,
          expandedHeight: widget._height * 0.2,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
               "ho".toUpperCase(), style: const TextStyle(
              fontFamily: 'Montserrat', color: Colors.black45,)),
            background: Image.asset("assets/images/color.jpg", fit: BoxFit.cover,),

          ),
        ),
         SliverToBoxAdapter(
          child: SizedBox(
            height: widget._height * 0.05,
            child: const Center(
              child: Text('No of devices connected : 3'),
            ),
          ),
        ),
        SliverList(

          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Material(color: Colors.transparent, child: Column(
                children: [
                  const SizedBox(height: 10),

                  ListTile(

                    leading: NeumorphicIcon(
                        Icons.cast_connected_outlined, size: 25,
                       ),
                    title: GestureDetector(onTap: () {
                      HapticFeedback.heavyImpact();

                    }, child: const Text(
                      "Devices not linked",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),),


                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            iconTheme: const IconThemeData(
                                color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: gotresult == true ? List.generate(list.length, (index) =>
                                    All_NoRoom_devices(list[index]))
                                    : [Center(child: Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: NeumorphicBoxShape.roundRect(
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
                                        color: Colors.black45, //customize color here
                                      ),
                                      textStyle: NeumorphicTextStyle(
                                        fontSize: 18, //customize size here
                                        // AND others usual text style properties (fontFamily, fontWeight, ...)
                                      ),
                                    ),),),
                                )),
                                ],)


                            ],
                          ),
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
    );



  }
}
