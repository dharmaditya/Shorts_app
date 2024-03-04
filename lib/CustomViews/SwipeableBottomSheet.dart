import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class SwipeableBottomSheet extends StatefulWidget {
  @override
  State<SwipeableBottomSheet> createState() => _SwipeableBottomSheetState();
}

class _SwipeableBottomSheetState extends State<SwipeableBottomSheet> {

  TextEditingController _commentController = TextEditingController();
  var comments = ['this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment ','this is a comment this is a comment this is a comment this is a comment this is a comment this is a comment '];

 @override
  void initState() {
    super.initState();
    comments.reversed;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Do nothing when dragging vertically.
        if (details.primaryDelta! > 5) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(26)),
        height:
            MediaQuery.of(context).size.height * 0.68,
            width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            // const Padding(
            //   padding: EdgeInsets.all(16.0),
            //   child: Text(
            //     'Swipeable Bottom Sheet',
            //     style: TextStyle(
            //       fontSize: 24.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 8,bottom: 36),
              child: Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      // child: const Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         CircleAvatar(
                      //           radius: 14,
                      //           backgroundColor: Colors.red,
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.only(left: 6),
                      //           child: Text('Profile Name',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                      //         )
                      //       ],
                      //     ),
                      //     Padding(
                      //       padding: EdgeInsets.only(left: 2),
                      //       child: Text('this is a comment this is a comment this is a comment this is a comment',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      //     )
                      //   ],
                      // ),
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10,right: 6),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 2),
                                child: Text(
                                  'Profile Name',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 2,right: 10),
                                width: MediaQuery.of(context).size.width * 0.85,
                                child:
                                // Text(
                                //   comments[index],
                                //   style: const TextStyle(
                                //       fontSize: 14, fontWeight: FontWeight.w400
                                //   ),
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                                ExpandableText(
                                  comments[index],
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  expandText: 'more',
                                  collapseText: 'less',
                                  maxLines: 2,
                                  linkColor: Colors.blue,

                                )
                              ),

                            ],
                          ),

                        ],
                      ),
                    );
                  },
                  itemCount: comments.length,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: Offset(0, 4), // Offset in x and y axis
                    ),
                  ]
                ),
                padding: EdgeInsets.only(left: 16),
                child:  TextField(
                  controller: _commentController,
                  decoration:  InputDecoration(
                    suffixIcon: GestureDetector(child: Icon(Icons.send,color: Colors.red,),onTap: () {
                      setState(() {
                        comments.insert(0, _commentController.text.toString());
                      });
                      _commentController.clear();
                    },),
                    hintStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color.fromARGB(
                        255, 243, 124, 120)),
                    hintText: 'Add a comment',
                    border: OutlineInputBorder(borderSide: BorderSide.none)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
