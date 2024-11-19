
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/VideoListProvider.dart';
import 'package:swiping_views/Screens/profile.dart';
import 'package:video_player/video_player.dart';
import '../CustomViews/SwipeableBottomSheet.dart';

class DisplayVideos extends StatelessWidget{


  var vids = [
    "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
  ];
  // List<int> vid_liked;
  // PageController? _pageController;
  int currentPage = 0;
  // VideoPlayerController ?_controllerCurrent;
  // VideoPlayerController? _controllerNxt;
  // Future<void>? _initializeVideoPlayerCurrent;
  // late TabController _tabController;
  int prevPage = 0;
  // bool pause = false;
  // @override
  // void initState() {
  //   super.initState();
  //   // context.read<VideoListProvider>().addVideos(vids);
  //   // _tabController = TabController(length: 2, vsync: this);
  //   vid_liked = List.generate(vids.length, (index) {
  //     return 0;
  //   });
  //   print('Liked :: ${vid_liked[2]}');
  //   _pageController = PageController(initialPage: currentPage);
  //   _pageController.addListener(_pageListener);
  //   _controllerCurrent = VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[0]));
  //   _controllerNxt = VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[1]));
  //   _initializeVideoPlayerCurrent = _controllerCurrent.initialize();
  //   _controllerCurrent.setLooping(true);
  // }

  // void _pageListener() {
  //   setState(() {
  //     prevPage = currentPage;
  //     currentPage = _pageController?.page?.round() ?? 0;
  //   });
  //   if (currentPage > prevPage) {
  //     print('Swiped forward');
  //   } else if (currentPage < prevPage) {
  //     print('Swiped backward');
  //   }
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   _controllerCurrent.dispose();
  //   _controllerNxt.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<VideoListProvider>(context);
    double width = MediaQuery.of(context).size.width;
    myProvider.setProfilePic();
    print('Image Url :: ${myProvider.profile_pic_url}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 220, 20, 18),
        centerTitle: true,

        title: const Text(
          'App Title',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
              },
              child:
              CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    imageUrl: myProvider.profile_pic_url!,
                    fit: BoxFit.fill,
                    width: 160,
                    height: 160,
                    placeholder: (context, url) =>
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 1.5,),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // bottomNavigationBar: TabBar(
      //   onTap: (value) {
      //     // Fluttertoast.showToast(msg: '$value');
      //     _controllerCurrent.pause();
      //   },
      //   tabs:  const [
      //     Tab(
      //         child:
      //         Icon(
      //       Icons.ondemand_video,
      //       color: Color.fromARGB(255, 220, 20, 18),
      //           size: 1,
      //     )
      //     ),
      //     Tab(
      //         child: Icon(
      //       Icons.account_circle,
      //       color: Color.fromARGB(255, 220, 20, 18),
      //           size: 1,
      //     ))
      //   ],
      //
      //   indicator: const BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //           topRight: Radius.circular(12),
      //           topLeft: Radius.circular(12),
      //           bottomLeft: Radius.circular(12)),
      //       color: Colors.transparent),
      // ),
      // BottomNavigationBar(
      //   backgroundColor: Colors.red.shade100,
      //   selectedItemColor: Colors.white,
      //   selectedIconTheme: IconThemeData(color: Colors.white),
      //   elevation: 0,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.ondemand_video,color: Color.fromARGB(255, 220, 20, 18),),label:'Videos'),
      //     BottomNavigationBarItem(icon: Icon(Icons.account_circle,color: Color.fromARGB(255, 220, 20, 18),),label: 'Profile'),
      //   ],
      // ) ,
      body:
        PageView.builder(
          scrollDirection: Axis.vertical,
          controller: myProvider.pageController,
          itemBuilder: (context, index) {
            print('current video '+myProvider.vid_links[index]);
            return Stack(children: [
              Container(
                color: Colors.black,
                child: Center(
                    child: GestureDetector(
                  onDoubleTap: () {},
                  onTap: () {
                    myProvider.play_pause();
                  },
                    child: Stack(alignment: Alignment.center, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 141, 244, 203),
                          borderRadius: BorderRadius.circular(20),

                      ),
                      child: FutureBuilder(
                        future:myProvider.initializeVideoPlayerCurrent,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (!myProvider.pause) {
                              myProvider.controllerCurrent.play();
                            }
                            return AspectRatio(
                              aspectRatio:
                                  myProvider.controllerCurrent.value.aspectRatio,
                              child: VideoPlayer(myProvider.controllerCurrent),
                            );
                          } else if (snapshot.hasError) {
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            );
                          } else {
                            return const Center(
                              child: SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: CircularProgressIndicator(
                                      color: Colors.white70,
                                      strokeWidth: 3)
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // Positioned(
                    //   bottom: 10,
                    //   child: Container(
                    //     alignment: Alignment.bottomLeft,
                    //     height: 100,
                    //     width: 100,
                    //     decoration: BoxDecoration(
                    //         color: const Color.fromARGB(255, 19, 97, 63),
                    //         borderRadius: BorderRadius.circular(20)
                    //     ),
                    //   ),
                    // ),
                    Icon(
                      Icons.play_arrow,
                      size: 48,
                      shadows: [
                        BoxShadow(
                          color: myProvider.pause
                              ? Colors.black.withOpacity(0.2)
                              : Colors
                                  .transparent, // Adjust shadow color and opacity
                          spreadRadius: 18,
                          blurRadius: 16,
                          offset: Offset(
                              0, 1), // Adjust the position of the shadow
                        ),
                      ],
                      color: myProvider.pause
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : Colors.transparent,
                    ),

                    // Visibility(
                    //   visible: pause,
                    //   child:  Center(
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             pause = true;
                    //           });
                    //         },
                    //           child: Icon(Icons.play_arrow, color: Color.fromARGB(200, 255, 255, 255),size:40,))
                    //   ),
                    //   ),
                  ]),
                )),
              ),
              Positioned(
                bottom: 1,
                child: Container(

                  color: Colors.black12,
                  width: width,
                  //margin: EdgeInsets.only(bottom: 12,left: 12),
                  //color: Color.fromARGB(100, 255, 255, 255),
                  padding: EdgeInsets.only(left: 12, right: 14, bottom: 2),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  'Profile Name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 6, left: 2),
                            width: width * 0.80,
                            child:
                              const ExpandableText(
                               'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ',
                               style: TextStyle(color: Colors.white),
                               expandText: 'show more',
                               collapseText: 'show less',
                               maxLines: 3,
                               linkColor: Colors.blue,
                             )
                            // Text(
                            //   'Mutliline descrtiption , asdas asdasdf dsf sdfsdf asd asd asdsdasdwfraefsef asd asd asddfgs rgdrgdg',
                            //   maxLines: 2,
                            //   style: TextStyle(
                            //       color: Colors.white70,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w400),
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          )
                        ],
                      ),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: GestureDetector(
                                  onTap: () {
                                    if(myProvider.vid_liked[index] == 0) {
                                      myProvider.liked_disliked(
                                          index, 1);
                                    }
                                    else{
                                      myProvider.liked_disliked(
                                          index, 0);
                                    }
                                    // if (vid_liked[index] == 0) {
                                    //   setState(() {
                                    //     vid_liked[index] = 1;
                                    //   });
                                    // } else {
                                    //   setState(() {
                                    //     vid_liked[index] = 0;
                                    //   });
                                    // }
                                  },
                                  child: Icon(
                                    myProvider.vid_liked[index] == 1
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_alt_outlined,
                                        size: 30,
                                        color: myProvider.vid_liked[index] == 1
                                        ? Colors.blue
                                        : Colors.white,
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: GestureDetector(
                                  onTap: () {

                                    if(myProvider.vid_liked[index] == 0) {
                                      myProvider.liked_disliked(
                                          index, 2);
                                    }
                                    else{
                                      myProvider.liked_disliked(
                                          index, 0);
                                    }

                                    // if (vid_liked[index] == 0) {
                                    //   setState(() {
                                    //     vid_liked[index] = 2;
                                    //   });
                                    // } else {
                                    //   setState(() {
                                    //     vid_liked[index] = 0;
                                    //   });
                                    // }
                                  },
                                  child: Icon(
                                    myProvider.vid_liked[index] == 2
                                        ? Icons.thumb_down
                                        : Icons.thumb_down_alt_outlined,
                                    size: 30,
                                    color: myProvider.vid_liked[index] == 2
                                        ? Colors.blue
                                        : Colors.white,
                                  )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: GestureDetector(
                                child: const Icon(
                                  Icons.comment_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  _showBottomSheet(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   child: const Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.only(bottom: 8.0),
                      //         child: Icon(Icons.thumb_up_alt_outlined,size: 30,color: Colors.white,),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.only(bottom: 8.0),
                      //         child: Icon(Icons.comment_outlined,size: 30,color: Colors.white,),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              )
            ]);
          },
          itemCount:
              context.watch<VideoListProvider>().vid_links.length, // Adjust the itemCount according to your needs
          onPageChanged: (value) {
            myProvider.pause = false;
            myProvider.controllerCurrent.dispose();
            // _controllerCurrent?.dispose();
            myProvider.controllerCurrent =
                VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[value]));
            myProvider.initializeVideoPlayerCurrent = myProvider.controllerCurrent.initialize();
            myProvider.controllerCurrent.setLooping(true);

            // if(value>=1) {
            //   _controllerPrev =
            //       VideoPlayerController.networkUrl(Uri.parse(vids[value - 1]));
            //   _initializeVideoPlayerPrev = _controllerPrev.initialize();
            // }
            //
            // _controllerCurrent = _controllerNxt;
            // _initializeVideoPlayerCurrent = _controllerCurrent.initialize();
            //
            // if(value<vids.length) {
            //   _controllerNxt =
            //       VideoPlayerController.networkUrl(Uri.parse(vids[value + 1]));
            //   _initializeVideoPlayerNxt = _controllerNxt.initialize();
            // }
          },
        ),
    );




  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) {
      return SwipeableBottomSheet();
    },
  );
}
