import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:thermostat/thermostat.dart';

class Favorites extends StatelessWidget {


  const Favorites({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body:    Neumorphic(child: Container(
          height: double.infinity,


            child:  SafeArea(
              minimum: EdgeInsets.all(15.0),

              maintainBottomViewPadding: true,
              top: true,
              left: true,
              bottom: true,
              right: true,
              child: ClipRect(

               child:
               Thermostat(
                 themeType:  NeumorphicTheme.of(context)!.isUsingDark? ThermostatThemeType.dark:ThermostatThemeType.light,
                 maxVal: 78,
                 minVal: 66,
                 curVal: 68,
                 setPoint: 73,
               ),



            ),
          ),
        ),
        ),

      );
}
