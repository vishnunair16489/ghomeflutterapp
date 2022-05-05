import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/room/add_device_container.dart';
class Add_device_from_list extends StatelessWidget {


  Add_device_from_list({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      final Container container = Container(child: design());

      return container;
    }

    Widget design() {
      return  Material(child:Add_Device_Container(),);
    }




}