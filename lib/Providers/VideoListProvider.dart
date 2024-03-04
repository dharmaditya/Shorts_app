import 'package:flutter/material.dart';

class VideoListProvider extends ChangeNotifier{
  var vid_links = [];

  void addVideos(List<String> videos){
    vid_links = videos;
  }
}