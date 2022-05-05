
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'googlesignin.dart';


class SigninGoogle extends StatelessWidget {

  const SigninGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(
        create: (_) => GoogleSignInProvider(),

        child:  const SigninGooglepage(),


      );

}

class SigninGooglepage extends StatefulWidget {



  const SigninGooglepage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SigninGooglepageState();
  }
}


class SigninGooglepageState extends State<SigninGooglepage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {



    final Container   container =Container(child: design());

    return container;
  }
  Widget design() {
    return SafeArea(child:Padding(padding: EdgeInsets.all(20),
      child:Center(heightFactor: double.infinity,child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center ,children:[Image.asset("assets/images/login.png",),
        SizedBox(height: 100,),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,

              minimumSize: const Size(double.infinity,50),
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          onPressed: ()  {
            final provider=Provider.of<GoogleSignInProvider>(context,listen: false);
            provider.googleLogin();

          }, icon: FaIcon(FontAwesomeIcons.google,color: Colors.green,), label: Text("google sign in"),),]),
      ),),);


  }


}
