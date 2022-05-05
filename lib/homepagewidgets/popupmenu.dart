import 'package:flutter/material.dart';

class Popupmenu extends StatelessWidget {
  const Popupmenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)=>const Scaffold(

    body: Center(
      child: Text('Favorites page',textScaleFactor: 3.0),
    ),

  );
}

showPopUpMenuAtPosition(BuildContext context, TapDownDetails details) {
  showMenu(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      details.globalPosition.dx,
      details.globalPosition.dy,
    ), items: [ PopupMenuItem<String>(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Add Accessory'),
            Icon(Icons.light, size: 20),
          ],),), value: '1'),
    PopupMenuItem<String>(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Add Room'),
              Icon(Icons.room, size: 20),
            ],),), value: '2'),
    PopupMenuItem<String>(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Add People'),
              Icon(Icons.people, size: 20),
            ],),), value: '3'),
    PopupMenuItem<String>(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Add Home'),
              Icon(Icons.home, size: 20),
            ],),), value: '4'),
  ]
    ,
    // other code as above
  );
}

