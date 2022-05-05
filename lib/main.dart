import 'package:alert/alert.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/HomePageInit.dart';
import 'package:ghomefinal/providers/providervalues.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constant_values/ipaddress.dart';
import 'firsttimeloginfiles/firsttimeloginsettings.dart';
import 'googlesignin/signingoogle.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(    ChangeNotifierProvider<Providervalues>(
    create: (_) => Providervalues(),
    child:  MyApp(),
  ),);
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return    NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'Neumorphic App',
        themeMode: ThemeMode.system,

      theme: const NeumorphicThemeData(
        baseColor: Color(0xffffffff),
        lightSource: LightSource.topLeft,

        depth: 0.5,

      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xff333333),
        lightSource: LightSource.topLeft,

        depth: 0.5,

      ),

    home: AnimatedSplashScreen(
        duration: 500,
        splashIconSize: double.infinity,
        splash:Image.asset("assets/images/splash.jpeg", fit: BoxFit.cover,   color: const Color(
            0xff5a5a5a).withOpacity(1.0),colorBlendMode:BlendMode.softLight ,),
        nextScreen:  MyHomePage(),
       ),);

  }
}

class MyHomePage extends StatefulWidget {
   bool newhouse=false;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ipaddressonline=onlineipaddress;
  final ipaddressoffline=offlineipaddress;
  @override
  void initState() {
    super.initState();
    broadcast();
    getvalue();
  }

  Future<void> getvalue() async {
    final SharedPreferences prefs = await _prefs;
    final String? action = prefs.getString('username');
    Alert(message: action.toString(), shortDuration: true).show();
  }
  Future insertuser() async  {
    final user = FirebaseAuth.instance.currentUser;
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));
    DateTime date=DateTime.now();
    String finaldate="";
   var results = await conn.query("select now();");
    for (var row in results)
    {
      date = row[0] as DateTime;
      finaldate = date.toString().substring(0,10) + ' ' + date.toString().substring(11,23);
    }
     results = await conn.query("select * from ghomeuser");
    if(results.isEmpty)
    {
      results = await conn.query("insert into ghomeuser(name,username,role,approved,onlinestatus,timestamp)values('" + user!.displayName.toString() + "','" +user!.email.toString()  +  "','ADMIN','true','offline','"+finaldate+"');");

      final provider=Provider.of<Providervalues>(context,listen: false);
      provider.add(results.insertId.toString());

    }
    else
    {
      bool flag=false;
      for (var row in results) {
        if(user!.email.toString()==row["username"])
        {
          final provider=Provider.of<Providervalues>(context,listen: false);
          provider.add(row["id"].toString());
          flag=true;
          break;
        }

      }

      if(!flag) {

        results = await conn.query("insert into ghomeuser(name,username,role,approved,onlinestatus,timestamp)values('" + user!.displayName.toString() + "','" +user!.email.toString()  +  "','USER','false','false','"+finaldate+"');");

        final provider=Provider.of<Providervalues>(context,listen: false);
        provider.add(results.insertId.toString());
      }
    }



    // Update some data

    await conn.close();
  }
  Future broadcast() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    var results = await conn.query("select * from ghomehouse");
    if(results.isEmpty)
    {
      HapticFeedback.heavyImpact();
     widget.newhouse=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(child:
    Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),builder: ( context,  snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasData){
              insertuser();
              return  widget.newhouse?FirstTimeLoginSettingsInit():HomePageinit();
            }

            else if(snapshot.hasError)
            {
              return(const Center(child: Text("hi three")));
            }

            else
            {
              return const SigninGoogle();
            }
          },

          ),),
      ),
    ),
    );
  }
}