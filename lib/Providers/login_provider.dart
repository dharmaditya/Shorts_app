import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier{
  bool passVisible = false;
  bool rememberMe = false;
  User? _user;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _user;

  bool get isLoading => _isLoading;
  SharedPreferences? prefs;



  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      startLoading();
      prefs = await SharedPreferences.getInstance();
      bool? success;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      print('userId - ${_user!.uid}');
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User_Details')
          .doc(_user!.uid)
          .get();
        if (documentSnapshot.exists) {

          print('Document exists on the database');
          print(documentSnapshot.data().toString());
          print(' User email - ${documentSnapshot.get("email")}');
          prefs!.setString('userId',_user!.uid);
          prefs!.setString('user_name',documentSnapshot.get('name'));
          prefs!.setInt('user_no_of_likes',documentSnapshot.get('no_of_likes'));
          prefs!.setInt('user_no_of_videos',documentSnapshot.get('no_of_likes'));
          prefs!.setString('user_profile_pic',documentSnapshot.get('profile_pic'));
          notifyListeners();
          stopLoading();
          return true;
        }
        else{
          print("Document not found");

          notifyListeners();
          stopLoading();
          return false;
        }


      // prefs!.setString('userId', _user!.uid);

    } on FirebaseAuthException catch (e) {
      print('Auth Exception :: $e');
      Fluttertoast.showToast(msg: 'Invalid Login Details');
      stopLoading();
      return false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e; // Handle error appropriately
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
  void passVisiblityChanged(){
    passVisible = !passVisible;
    notifyListeners();
  }
  void rememberMeChanged(){
    rememberMe = !rememberMe;
    notifyListeners();
  }
}