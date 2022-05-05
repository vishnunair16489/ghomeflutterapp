
import 'dart:convert';
import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Online_Offline extends StatefulWidget {

  bool value=false;
  Online_Offline({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Online_OfflineState();
  }
}

class Online_OfflineState extends State<Online_Offline> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> setvalue(bool mode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('mode', mode);


  }
  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final bool? action = prefs.getBool('mode');
    setState(() {
      widget.value=action! ;

    });

    Alert(message: action.toString(), shortDuration: true).show();

  }

  void createAlbum(String title) async {
    var clinet=http.Client();


    final response = await clinet.post(
      Uri.parse("http://192.168.74.66:8080/api"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'status': "inset into",
      }),
    );


  }
  @override
  void initState() {
    super.initState();
    createAlbum("vishnu");
    getvalue();

  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child:
      ElevatedButton(
        onPressed: () {
          setState(() {
           createAlbum("ggdg");
          });
        },
        child: const Text('Create Data'),
      ),






    );
  }
}