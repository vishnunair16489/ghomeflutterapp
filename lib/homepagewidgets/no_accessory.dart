import 'package:flutter/material.dart';

class No_Accessory  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child: Theme(
        data:
        Theme.of(context).copyWith(iconTheme: const IconThemeData(color: Colors.white)),
        child:
        Padding(padding: const EdgeInsets.all(5.0),
          child:
          Column(
            children: [
              Card(
                //  elevation: 2,
                color: const Color.fromRGBO(255, 255 , 255, 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(20),
                ),
                child:
                SizedBox(
                  width: 100,
                  height: 100,
                  child:
                  IconButton(
                    icon: const Icon(Icons.home, size: 30,),
                    onPressed: () {},),
                ),
              ),
              const Text('My Home', textScaleFactor: 0.9,
                  style: TextStyle(color: Colors.white,)),
            ],
          ),
        ),
      ),
    );
  }
}