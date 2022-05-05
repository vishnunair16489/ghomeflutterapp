
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Homeonline extends StatefulWidget {
  final String isuseronline,housetype,housename,isonline;
  bool valueinit=true;


  Homeonline( this.isuseronline,  this.housetype,  this.housename,  this.isonline, {Key? key}) : super(key: key);
  @override
  _HomeonlineState createState() => _HomeonlineState();
}

class _HomeonlineState extends State<Homeonline> {
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
    final user=FirebaseAuth.instance.currentUser;



    return  Container(child:Column(
      mainAxisAlignment:MainAxisAlignment.start
      ,children: [
      CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(user!.photoURL.toString()),
      ),
      SizedBox(height: 10,),
      Text(user!.displayName.toString()),
      SizedBox(height: 30,),

      CheckboxListTile(
        activeColor: NeumorphicTheme.of(context)!.isUsingDark ? NeumorphicColors
            .darkAccent : NeumorphicColors.accent,
        secondary: Icon(Icons.network_wifi,
          color: NeumorphicTheme.of(context)!.isUsingDark ? NeumorphicColors
              .darkAccent : NeumorphicColors.accent,),
        title:  Text('Connect ${user!.displayName.toString().toUpperCase()} online'),
        subtitle:  Text(
            '${user!.displayName.toString()}.You can connect to your home network from anywhere in the world '),
        value:widget.isuseronline.toString()=="online"?true:false,
        onChanged: (value) {


        },
      ),
      SizedBox(height: 30,),
      Text("House Type : "+widget.housetype.toString()),
      SizedBox(height: 30,),
      Text("House Name : "+widget.housename.toString().toUpperCase()),
      SizedBox(height: 30,),
      CheckboxListTile(
        activeColor: NeumorphicTheme.of(context)!.isUsingDark ? NeumorphicColors
            .darkAccent : NeumorphicColors.accent,
        secondary: Icon(Icons.network_wifi,
          color: NeumorphicTheme.of(context)!.isUsingDark ? NeumorphicColors
              .darkAccent : NeumorphicColors.accent,),
        title:  Text('Connect ${widget.housename.toString().toUpperCase()} ${widget.housetype.toString().toUpperCase()} online'),
        subtitle:  Text(
            '${user!.displayName.toString()}.Your house can be accessible from anywhere in the world '),
        value:widget.isonline.toString()=="online"?true:false,
        onChanged: (value) {


        },
      ),

    ],),

    );
  }
}