
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:ghomefinal/newdevice/btninfo.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'animated_card_widget.dart';
import 'ipaddress.dart';


class Popup_Window extends StatefulWidget {
  final String devicetype;
  final String noofswitches;
  final int code;
  late final int deviceid;
  final String roomid;
    late  String deviefoundtype;
    Popup_Window(this.devicetype, this.noofswitches,this.code,this.roomid, {Key? key}) : super(key: key);



  @override
  _Popup_WindowState createState()
  {
    return _Popup_WindowState();
  }
}


class _Popup_WindowState extends State<Popup_Window> {


  TextEditingController devicenamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    switch ( widget.devicetype) {
      case "T":
        widget.deviefoundtype="Touch Screen";
        break;
      case "D":
        widget.deviefoundtype="Smart Plug";
        break;

    }
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
    {


      design(),
    });
  }


  @override
  Widget build(BuildContext context) {

    return Container(

    );
  }

  void design() {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context,) =>
 Center(
                child: Neumorphic(
                  margin: const EdgeInsets.all(7.0),
                  style: const NeumorphicStyle(
                    shape: NeumorphicShape.flat,

                  ),
                  child: NeumorphicBackground(child: Material(child: Container(

                    padding: const EdgeInsetsDirectional.all(20),
                    alignment: Alignment.center,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .copyWith()
                        .size
                        .height * 0.60,
                    child: SingleChildScrollView(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                         Text(
                            widget!.deviefoundtype.toUpperCase()+" FOUND!!!", textScaleFactor: 1.5,
                            style: const TextStyle(fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,)),

                        Center(
                          child: AnimatedCardWidget(),
                        ),
                        const SizedBox(height: 16,),


                        Neumorphic(
                          style: const NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.stadium(),
                            shape: NeumorphicShape.flat,
                            depth: -5,
                          ),
                          child:  TextField(
                                controller: devicenamecontroller,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  hintText: "Kitchen  All Lights",
                                  labelText: "Enter the switch name (Optional)",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.grey,),
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                  border: InputBorder.none,
                                  fillColor: Colors.black12,
                                  filled: false),


                          ),
                        ),

                        const SizedBox(height: 16,),

                        SwipeButton.expand(
                          thumb: const Icon(
                            Icons.double_arrow_rounded,
                            color: Colors.white,
                          ),
                          child: const Text(
                            "Swipe to enter details and save",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          activeThumbColor: Colors.red,
                          activeTrackColor: Colors.grey.shade300,
                          onSwipe: () {
                               broadcast(devicenamecontroller.text,widget.roomid);

                          },
                        )
                      ],

                    ),),

                  ),
                  ),
                  ),
                ),


              ),


    );
  }


  Future broadcast(String devicenamecontroller,String roomid) async {

    final ipaddressoffline=offlineipaddress;
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: ipaddressoffline,
        port: 3306,
        user: 'geetron',
        db: 'ghomeserver',
        password: 'western@1010'));

    // Create a table
    String devicename="";

    if(devicenamecontroller=="") {

      devicename=  widget.deviefoundtype;



    }
    else
    {
      devicename=devicenamecontroller;
    }
   late Results results;
    if(roomid=="NULL")
      {
        results = await conn.query(   "insert into ghomedevice(devicetype,devicename,houseid )values('" +
            widget.devicetype + "','" + devicename + "',1)");


      }
    else
      {
         results = await conn.query(   "insert into ghomedevice(devicetype,devicename,houseid,roomid )values('" +
            widget.devicetype + "','" + devicename + "',1,"+roomid+")");

      }
    print('inserted1: $results');
    String address='';
    if(int.parse(results.insertId.toString())<10)
    {
      address="0"+results.insertId.toString();
    }
    else{
      address=results.insertId.toString();
    }
    widget.deviceid=results.insertId!;
    for(int i=1;i<=int.parse(widget.noofswitches);i++)
    {

      await conn.query(   "insert into ghomebutton(buttonname,buttonaddress,deviceid,houseid )values('','" +i.toString()+ address + "','"+results.insertId.toString()+"','1')");
      await conn.query(   "insert into ghomedevicestatus(address,status,lastupdated,deviceid )values(" +i.toString()+ address + ",0,now(),'"+results.insertId.toString()+"')");
    }




    await conn.close();
    Navigator.of(context).pop();
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>
        Btn_Info_Init(widget.deviceid)));
  }



}
