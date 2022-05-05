
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/fav_decive_template.dart';
import 'package:mysql1/mysql1.dart';

import '../constant_values/ipaddress.dart';

class Fav_Device_Container extends StatefulWidget {

  const Fav_Device_Container({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return Fav_Device_ContainerState();
  }
}

class Fav_Device_ContainerState extends State<Fav_Device_Container> {


  late List<int> list=[];
  bool gotresult=false;

  @override
  void initState() {
    super.initState();
    broadcast();
  }

  Future broadcast() async {
    final ipaddressonline=onlineipaddress;
    final ipaddressoffline=offlineipaddress;
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table


    var results = await conn.query( 'select * from ghomehouse;');
    for (var row in results) {
      list.add( row[0]);
    }
    setState(() {
      gotresult=true;

    });


    // Update some data

    await conn.close();
  }
  @override

  @override
  Widget build(BuildContext context) {




    final Container container = Container(child: design());

    return container;
  }


  Widget design() {
    return SizedBox(
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("MY HOME", textScaleFactor: 1.75,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height:5,),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            child:  Row(

                children: gotresult == true ? List.generate(list.length, (index) =>
                   Fav_Device_Template())
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
                ],


              ),
          ),


            ],
          ),
        ),
      ),

    );
  }
}
