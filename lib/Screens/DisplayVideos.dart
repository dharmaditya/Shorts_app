
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/VideoListProvider.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../CustomViews/SwipeableBottomSheet.dart';

class DisplayVideos extends StatefulWidget {
  const DisplayVideos({super.key});
  @override
  State<DisplayVideos> createState() => _DisplayVideosState();
}

class _DisplayVideosState extends State<DisplayVideos>
    with SingleTickerProviderStateMixin {
  var vids = [
    "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
  ];
  late List<int> vid_liked;
  late PageController _pageController;
  int currentPage = 0;
  late VideoPlayerController _controllerCurrent;
  late VideoPlayerController _controllerPrev;
  late VideoPlayerController _controllerNxt;
  late Future<void> _initializeVideoPlayerCurrent;
  late TabController _tabController;
  late Future<void> _initializeVideoPlayerPrev;
  late Future<void> _initializeVideoPlayerNxt;
  int prevPage = 0;
  bool pause = false;
  @override
  void initState() {
    super.initState();
    context.read<VideoListProvider>().addVideos(vids);
    _tabController = TabController(length: 2, vsync: this);
    vid_liked = List.generate(vids.length, (index) {
      return 0;
    });
    print('Liked :: ${vid_liked[2]}');
    _pageController = PageController(initialPage: currentPage);
    _pageController.addListener(_pageListener);
    _controllerCurrent = VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[0]));
    _controllerNxt = VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[1]));
    _initializeVideoPlayerCurrent = _controllerCurrent.initialize();
    _initializeVideoPlayerNxt = _controllerNxt.initialize();
    _controllerCurrent.setLooping(true);
  }

  void _pageListener() {
    setState(() {
      prevPage = currentPage;
      currentPage = _pageController.page?.round() ?? 0;
    });
    if (currentPage > prevPage) {
      print('Swiped forward');
    } else if (currentPage < prevPage) {
      print('Swiped backward');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerCurrent.dispose();
    _controllerPrev.dispose();
    _controllerNxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 220, 20, 18),
            centerTitle: true,
            title: (Text(
              'App Title',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
            )),
          ),
        ),
        bottomNavigationBar: TabBar(
          onTap: (value) {
            // Fluttertoast.showToast(msg: '$value');
            _controllerCurrent.pause();
          },
          tabs:  const [
            Tab(
                child:
                Icon(
              Icons.ondemand_video,
              color: Color.fromARGB(255, 220, 20, 18),
                  size: 1,
            )
            ),
            Tab(
                child: Icon(
              Icons.account_circle,
              color: Color.fromARGB(255, 220, 20, 18),
                  size: 1,
            ))
          ],

          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
              color: Colors.transparent),
        ),
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
        body: TabBarView(children: [
          Container(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemBuilder: (context, index) {
                return Stack(children: [
                  Container(
                    color: Colors.black,
                    child: Center(
                        child: GestureDetector(
                      onDoubleTap: () {},
                      onTap: () {
                        print(
                            'playing :: ${_controllerCurrent.value.isPlaying}');
                        print('playing :: ${_controllerCurrent.value}');
                        if (_controllerCurrent.value.isPlaying) {
                          _controllerCurrent.pause();
                          setState(() {
                            pause = true;
                          });
                        } else {
                          _controllerCurrent.play();
                          setState(() {
                            pause = false;
                          });
                        }
                      },
                        child: Stack(alignment: Alignment.center, children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 141, 244, 203),
                              borderRadius: BorderRadius.circular(20),

                          ),
                          child: FutureBuilder(
                            future: _initializeVideoPlayerCurrent,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (!pause) {
                                  _controllerCurrent.play();
                                }
                                return AspectRatio(
                                  aspectRatio:
                                      _controllerCurrent.value.aspectRatio,
                                  child: VideoPlayer(_controllerCurrent),
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
                              color: pause
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors
                                      .transparent, // Adjust shadow color and opacity
                              spreadRadius: 18,
                              blurRadius: 16,
                              offset: Offset(
                                  0, 1), // Adjust the position of the shadow
                            ),
                          ],
                          color: pause
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
                                        if (vid_liked[index] == 0) {
                                          setState(() {
                                            vid_liked[index] = 1;
                                          });
                                        } else {
                                          setState(() {
                                            vid_liked[index] = 0;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        vid_liked[index] == 1
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_alt_outlined,
                                            size: 30,
                                            color: vid_liked[index] == 1
                                            ? Colors.blue
                                            : Colors.white,
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        if (vid_liked[index] == 0) {
                                          setState(() {
                                            vid_liked[index] = 2;
                                          });
                                        } else {
                                          setState(() {
                                            vid_liked[index] = 0;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        vid_liked[index] == 2
                                            ? Icons.thumb_down
                                            : Icons.thumb_down_alt_outlined,
                                        size: 30,
                                        color: vid_liked[index] == 2
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
                pause = false;
                _controllerCurrent.dispose();
                _controllerCurrent =
                    VideoPlayerController.networkUrl(Uri.parse(context.read<VideoListProvider>().vid_links[value]));
                _initializeVideoPlayerCurrent = _controllerCurrent.initialize();
                _controllerCurrent.setLooping(true);

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
          ),
          Container(
            color: Colors.redAccent,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 28),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Likes',style: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w600),),
                            Text('videos',style: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.w600),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 26),
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Colors.black45,
                ),
                Container(
                 child:GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3, // Number of columns in the grid
                   crossAxisSpacing: 5.0, // Spacing between columns
                   mainAxisSpacing: 5.0, // Spacing between rows
                 ),
                     itemBuilder: (context, index) {
                       return SizedBox(
                         width: 80,
                         height: 250,
                       );
                     },
                 itemCount: 8,
                 ),
                )
              ],
            ),
          )
        ]),
        resizeToAvoidBottomInset: false,
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
