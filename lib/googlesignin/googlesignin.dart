import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googlesignin=GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;


  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future googleLogin() async
  {
    try {
      final googleUser = await googlesignin.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleauth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      setvalue(_user!.email);
      notifyListeners();
    }
    catch( E){}
  }
  Future googleLogout() async
  {
   await googlesignin.disconnect();
   FirebaseAuth.instance.signOut();

  }
  Future<void> setvalue(String id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('username', id);


  }
  Future<void> setvalueid(String id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('id', id);


  }



}