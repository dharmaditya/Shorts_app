import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier{
  String? profile_pic_url;
  String? name;
  int? no_of_likes;
  int? no_of_vids;
  bool _isLoading = false;

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

  Future<void> setProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile_pic_url = prefs.getString('user_profile_pic');
    name = prefs.getString('user_name');
    no_of_likes = prefs.getInt('user_no_of_likes');
    no_of_vids = prefs.getInt('user_no_of_videos');
    print('Image Url :: $profile_pic_url');
    notifyListeners();
  }


    Future<void> getUserVideos()async{
    prefs = await SharedPreferences.getInstance();
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User_Details')
          .doc(prefs!.getString('userId')!)
          .get();
      if(documentSnapshot.exists){
        // Fluttertoast.showToast(msg: 'Data Found');
      }
      else{
        // Fluttertoast.showToast(msg: 'Data Not Found');
      }
    }


}