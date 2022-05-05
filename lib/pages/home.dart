import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/homepagewidgets/all_accessory_container.dart';
import 'package:ghomefinal/pages/homepage.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool refreshhome = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
  //  super.dispose();
  }

  Future<void> refresh() async {
    {
      setState(() {
        refreshhome = !refreshhome;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(

      body: RefreshIndicator(
        onRefresh: refresh,
        child: SizedBox(
          height: double.infinity,

          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.antiAlias,
              child: !refreshhome ? load(height) : load(height)

          ),
        ),
      ),

    );
  }

  Widget load(double height) {
    return SafeArea(
      top: false,

      bottom: true,

      child: Center(
        child: Stack(children: [   Column(
          children: [
            HomePagelayout(height),
            const All_Accessory_ContainerInit()
          ],
        )
        ],
        ),

      ),
    );
  }
}
