import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
class DeviceStatus extends StatefulWidget {
  final int id;
  const DeviceStatus(this.id,{Key? key}) : super(key: key);

  @override
  _DeviceStatusState createState()
  {
    return _DeviceStatusState();
  }
}

class  _DeviceStatusState extends State<DeviceStatus> {
  double selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return  Hero(tag: 'trial' + widget.id.toString(),child:Material(
        child: Container(
            margin: const EdgeInsets.only(top:100, left: 20, right: 20),
            width: double.infinity,
            child:Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SleekCircularSlider(

                      appearance:  CircularSliderAppearance(size:250, customWidths: CustomSliderWidths(progressBarWidth: 20),),
                      onChange: (double value) {
                        print(value);
                      }),
                ),
                const SizedBox(
                    height:30
                ),
                Text("$selectedValue"),
              ],
            )
        ),
    ),


    );
  }
}
