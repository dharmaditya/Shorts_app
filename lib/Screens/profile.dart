import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final _profileProvider = Provider.of<ProfileProvider>(context);
    _profileProvider.setProfileData();
    _profileProvider.getUserVideos();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Profile',style: TextStyle(fontSize: 22,color: Colors.white, fontWeight: FontWeight.w700),),
      centerTitle: true,
        backgroundColor: Colors.red,
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: 20),
        child: FloatingActionButton(onPressed: () {
        },
        backgroundColor: Colors.red,
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(19),bottomStart: Radius.circular(19))
              ),
              padding: const EdgeInsets.only(top: 14),
              height: MediaQuery.of(context).size.height * 0.225,
              child:   Column(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          imageUrl: _profileProvider.profile_pic_url!,
                          fit: BoxFit.fill,
                          width: 160,
                          height: 160,
                          placeholder: (context, url) =>
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(strokeWidth: 1.5,),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Text(_profileProvider.name ?? '--',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                  Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_profileProvider.no_of_likes.toString(),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                            Text('Likes',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_profileProvider.no_of_vids.toString(),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                            Text('Videos',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            //margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            height: 2,
            color: Colors.black45,
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.62,
              child: GridView.builder(padding : const EdgeInsets.all(12.0),
                itemCount: 10,
                gridDelegate:   SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.44,
                      crossAxisSpacing: 2,
                    mainAxisSpacing: 4,
                    mainAxisExtent: 200
                ),
                itemBuilder: (context, index) {
                  return GridTile(child:
                  Container(
                    height: 120,
                    width: 60,
                    color: Colors.grey,
                  )
                  );
                },

              ),
            ),
          )
        ],
      ),
    );
  }
}
