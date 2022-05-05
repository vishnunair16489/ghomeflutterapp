import 'package:alert/alert.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant_values/main__pages.dart';
import 'constant_values/menu_icons.dart';
import 'constant_values/menu_icons_light.dart';

class HomePageinit extends StatelessWidget {
  const HomePageinit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int index = 2;
  final mainpages = pages;
  final menuicon = menuicons;
  final menuiconlight = menuiconslight;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();

    getvalue();

  }


  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final String? action = prefs.getString('username');

    Alert(message: action.toString(), shortDuration: true).show();

  }
  @override
  Widget build(BuildContext context) {

    return  Neumorphic(child:
    Scaffold(



      extendBody: true,
      backgroundColor: Colors.white,
      body: mainpages[index],
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        height: 60.0,
        color: NeumorphicTheme.of(context)!.isUsingDark? const Color(0xff333333): Colors.white,
        buttonBackgroundColor:  NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 350),

        items: NeumorphicTheme.of(context)!.isUsingDark? menuicon:menuiconlight ,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },

      ),
    ),

    );
  }
}