import 'package:flutter/material.dart';

class DeviceDimmer extends StatefulWidget {
  final String id;
  const DeviceDimmer(this.id,{Key? key}) : super(key: key);
  @override
  _DeviceDimmerState createState() => _DeviceDimmerState();
}

class _DeviceDimmerState extends State<DeviceDimmer> {
  double value = 75;

  @override
  Widget build(BuildContext context) {
    const double min = 0;
    const double max = 100;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 90,
        thumbShape: SliderComponentShape.noOverlay,
        overlayShape: SliderComponentShape.noOverlay,
        valueIndicatorShape: SliderComponentShape.noOverlay,


        /// ticks in between
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child:  Hero(tag: 'trial' + widget.id.toString(), child: Material(

            child: Column(
              children: [

                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: value,
                          min: min,
                          max: max,
                          divisions: 20,
                          label: value.round().toString(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${value.round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),


      ),
    );
  }

}
