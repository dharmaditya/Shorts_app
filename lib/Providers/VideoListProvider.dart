import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoListProvider extends ChangeNotifier{
  var vid_links = [
    "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
  ];

  late List<int> vid_liked;
  PageController? pageController;
  int currentPage = 0;
  late VideoPlayerController controllerCurrent;
  late VideoPlayerController controllerNxt;
  late Future<void> initializeVideoPlayerCurrent;
  int prevPage = 0;
  bool pause = false;
  String? profile_pic_url;

  VideoListProvider(){
    vid_liked = List.generate(vid_links.length, (index) {
      return 0;
    });
    print('Liked :: ${vid_liked[2]}');
    pageController = PageController(initialPage: currentPage);
    pageController?.addListener(pageListener);
    controllerCurrent = VideoPlayerController.networkUrl(Uri.parse(vid_links[0]));
    controllerNxt = VideoPlayerController.networkUrl(Uri.parse(vid_links[1]));
    initializeVideoPlayerCurrent = controllerCurrent.initialize();
    controllerCurrent.setLooping(true);
    setProfilePic();
    notifyListeners();
  }

  Future<void> setProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile_pic_url = prefs.getString('user_profile_pic');
    print('Image Url :: $profile_pic_url');
    notifyListeners();
  }

  @override
  void dispose() {
    pageController?.dispose();
    controllerCurrent.dispose();
    controllerNxt.dispose();
    super.dispose();
  }

  void play_pause(){
    if(controllerCurrent.value.isPlaying){
      controllerCurrent.pause();
      pause = true;
    }
    else{
      controllerCurrent.play();
      pause = false;
    }
    notifyListeners();
  }

  void liked_disliked(int index, int liked_disliked){
    vid_liked[index] = liked_disliked;
    notifyListeners();
  }

  void pageListener() {
      prevPage = currentPage;
      currentPage = pageController?.page?.round() ?? 0;
    if (currentPage > prevPage) {
      print('Swiped forward');
    } else if (currentPage < prevPage) {
      print('Swiped backward');
    }
    notifyListeners();
  }
  // void addVideos(List<String> videos){
  //   vid_links = videos;
  // }
}