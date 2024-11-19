import 'package:flutter/cupertino.dart';

class CommentsProvider extends ChangeNotifier{
  var comments = ['this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment '];

  void insertComment(String comment){
    comments.insert(0, comment);
    notifyListeners();
  }
}