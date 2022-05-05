import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../googlesignin/googlesignin.dart';

class TrialLogged extends StatelessWidget{

  TrialLogged({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;
     return Material(child: SafeArea( child: Container(
       child: Column(children: [
         CircleAvatar(
           radius: 40,
           backgroundImage: NetworkImage(user!.photoURL.toString()),
         ),
         Text(user!.displayName.toString()),

         Text(user!.email.toString()),
         ElevatedButton.icon(onPressed: () async {
           final provider=Provider.of<GoogleSignInProvider>(context);
          provider.googleLogout();



         }, icon: FaIcon(FontAwesomeIcons.camera,color: Colors.white,), label: Text("logout"))


       ],),

     ),),
     );
  }







}