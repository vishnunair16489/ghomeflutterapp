import 'package:alert/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/googlesignin/trialloged.dart';
import 'package:ghomefinal/newdevice/newdeviceloadingpage.dart';
import 'package:ghomefinal/room/newroom.dart';
import 'package:ghomefinal/user/newuser.dart';
import 'package:page_transition/page_transition.dart';

import '../house/edithouse.dart';


class Appbar  extends StatelessWidget {
  final String role;
   Appbar(this.role,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.all(8.0),
    child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(

            radius: 20,
            backgroundImage: NetworkImage(user!.photoURL.toString()),
          ),
          GestureDetector(
            child:  const Icon(Icons.menu, size: 30  , color: Colors.white),
            onTapDown: (details) => role!="ADMIN"?showPopUpMenuAtPosition(context, details):  Alert(message: "You dont have permission", shortDuration: true).show(),
          ),

        ],
    ),

    );
  }

  showPopUpMenuAtPosition(BuildContext context, TapDownDetails details) {
    showMenu(
      context: context,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0)),),

      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ), items: [ PopupMenuItem<String>(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text('Add Accessory' ),
              Icon(Icons.light, size: 20 ,    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,),
            ],),), value: '1'),
      PopupMenuItem<String>(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text('Add Room' ),
                Icon(Icons.room,  size: 20,    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,),
              ],),
          ), value: '2'
      , onTap: () {
    HapticFeedback.heavyImpact();}),
      PopupMenuItem<String>(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text('Add to Network'),
                Icon(Icons.leak_add, size: 20,    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,),
              ],),), value: '3'),
      PopupMenuItem<String>(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [

                const Text('Edit Home'),
                Icon(Icons.home, size: 20,    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,),
              ],),), value: '4'),
      PopupMenuItem<String>(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [

                Text('User Setting'),
                Icon(Icons.settings, size: 20,    color: NeumorphicTheme.of(context)!.isUsingDark? NeumorphicColors.darkAccent: NeumorphicColors.accent,),
              ],),), value: '5'),
    ],elevation:8.0,).then((value) =>
       { if (value != null)
    if(value == "1"){
      HapticFeedback.heavyImpact(),
    Navigator.push(context, PageTransition(type:  PageTransitionType.scale, alignment: Alignment.center, child: const NewDeviceLoadingPage())),
    //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>    const NewDeviceLoadingPage() )),
    }else if(value == "2"){
        HapticFeedback.heavyImpact(),
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>   NewRoom() )),
    }else{if(value == "3"){
      HapticFeedback.heavyImpact(),
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>    NewUser() )),
    }else if(value == "4"){
      HapticFeedback.heavyImpact(),
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>   const EditHouseInit() )),
    }
    else if(value == "5"){
        HapticFeedback.heavyImpact(),
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>    TrialLogged() )),
      }
      //code here
    }
  }
      // other code as above
    );
  }
}