
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ghomefinal/firsttimeloginfiles/insertintodatabase.dart';
import 'package:ghomefinal/firsttimeloginfiles/useronline.dart';
import 'package:ghomefinal/house/newhouse.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

import '../providers/providervalues.dart';
import 'homeonline.dart';


class FirstTimeLoginSettingsInit extends StatefulWidget {
  const FirstTimeLoginSettingsInit({Key? key}) : super(key: key);

  @override
  _FirstTimeLoginSettings createState() => _FirstTimeLoginSettings();
}

class _FirstTimeLoginSettings extends State<FirstTimeLoginSettingsInit> {
  int activeStep = 0;
  int upperBound = 4;

  String housetype = "";
  String housename = "";
  String isonline = "online";
  String isuseronline = "online";
  String useridvalue = "";
  set housetypestring(String value) => setState(() => housetype = value);
  set housenamestring(String value) => setState(() => housename = value);
  set isonlinestring(String value) => setState(() => isonline = value);
  set isuseronlinestring(String value) => setState(() => isuseronline = value);

  @override
  Widget build(BuildContext context) {
    final Providervalues userid = Provider.of<Providervalues>(context);
    useridvalue=userid.id.toString();
    return Neumorphic(
      child: SafeArea(child: Scaffold(

        body: SingleChildScrollView(
          child:Container(
            height: MediaQuery
                .of(context)
                .size
                .height*0.95,
          child: Padding(
          padding: const EdgeInsets.all(8.0),
         child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            IconStepper(
              enableNextPreviousButtons: false,
              icons: const[
                Icon(Icons.email),
                Icon(Icons.flag),
                Icon(Icons.access_alarm),
                Icon(Icons.supervised_user_circle),
                Icon(Icons.flag),
              ],
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            header(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                previousButton(),
                nextButton(userid.id.toString()),
              ],
            ),
          ],
          ),

          ),

        ),),),),


    );
  }

  /// Returns the next button.
  Widget nextButton(String userid) {
    return  Visibility(
    child:  FloatingActionButton(

      onPressed: activeStep==4?null: btnpress,

      tooltip: 'Increment',
      child: const Icon(Icons.arrow_forward),
    ),
    visible: activeStep==4?false:true,
    );

  }
  Function? btnpress() {if (activeStep < upperBound) {
    setState(() {
      activeStep++;
    });
  }


  }

  /// Returns the previous button.
  Widget previousButton() {
    return  Visibility(child: FloatingActionButton(
    onPressed: () {
    // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
    if (activeStep > 0) {
    setState(() {
    activeStep--;
    });
    }
    },
    tooltip: 'Increment',
    child: const Icon(Icons.arrow_back),
    ),
      visible: activeStep==4?false:true,
    );

  }

  /// Returns the header wrapping the header text.
  Widget header() {
    switch (activeStep) {
      case 1:
        return UserOnline(isuseronlinestring: (val) => setState(() { isuseronline = val;}),);

      case 2:

        return   NewHouse(housetypestring: (val) => setState(() { housetype = val;}), isonlinestring: (String val) => setState(() { housename = val;}), housenamestring: (String val) => setState(() { isonline = val;}),);

      case 3:
        return Homeonline(isuseronline,housetype,isonline,housename);
      case 4:

        return InsertIntoDatabase(isuseronline,housetype,isonline,housename,useridvalue);


      default:
        return NeumorphicBackground(child:Container(
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(5),
          ),
          child:Center(child:Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  headerText(),

                ),
              ),
            ],
          ),
          ),
        ),
        );
    }
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'online available';

      case 2:
        return 'New House';

      case 3:
        return 'online available';


      case 4:
        return 'Final configuration';


      default:
        return 'Hi there\nWelcome to Geetron smart Home\nSome things need to setup and then we are set to go';
    }
  }
}