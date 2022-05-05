
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/providers/providervalues.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool valueinit =false;
typedef void isuseronlinestringCallback(String val);
class UserOnline extends StatefulWidget {

  final isuseronlinestringCallback isuseronlinestring;


  UserOnline({Key? key, required this.isuseronlinestring}) : super(key: key);
  @override
  _UserOnlineState createState() => _UserOnlineState();
}

class _UserOnlineState extends State<UserOnline> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String id="";

  late Providervalues useridfinal;
  late int code;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    id = prefs.getString('id')!;



  }
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

    return Container(child: Column(children: [
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
        title: const Text('Connect online'),
        subtitle: const Text(
            'You can connect to your home network from anywhere in the world '),
        value:valueinit,
        onChanged: (value) {

          setState(() {

            if(value as bool) {
              widget.isuseronlinestring("online");
             valueinit = value as bool;
              print(  valueinit);
            }
            else
              {
                widget.isuseronlinestring("offline");
                valueinit = value as bool;
                print( valueinit);
              }
          });
        },
      ),
    ],),

    );
  }
}

