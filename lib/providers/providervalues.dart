import 'package:flutter/cupertino.dart';

class Providervalues extends ChangeNotifier {
   String?  _id;

   String? get id => _id;
  void add(String id) {
   _id=id;
    notifyListeners();
  }

}