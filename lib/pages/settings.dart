import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/settings/onlineoffline.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
     SingleChildScrollView(

          child: SafeArea(
            minimum: EdgeInsets.all(15.0),

            maintainBottomViewPadding: true,
            top: true,
            left: true,
            bottom: true,
            right: true,
            child: ClipRect(
              child: Container(child: Online_Offline()),
            ),
          ),







      );

}
