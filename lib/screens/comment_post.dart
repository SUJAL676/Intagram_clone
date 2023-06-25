import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post/post_firebase.dart';
import 'package:instagram_clone/responses/android.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/widget/comment_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';

class Comment_Post extends StatefulWidget {
  final String postid;
  const Comment_Post({Key? key, required this.postid, }) : super(key: key);

  @override
  State<Comment_Post> createState() => _Comment_PostState();
}

class _Comment_PostState extends State<Comment_Post> {

  TextEditingController comment=TextEditingController();

  @override
  void dispose()
  {
    super.dispose();
    comment.dispose();
  }


  @override
  Widget build(BuildContext contextl) {
    User user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("COMMENTS"),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> android()) );
        },),
        backgroundColor: mobileBackgroundColor,
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 713,
              child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('post').doc(widget.postid).collection('comment').orderBy("date_time").snapshots(),
                        builder: (context ,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
                        {
                          if (snapshot.connectionState==ConnectionState.waiting)
                          {
                            return CircularProgressIndicator();
                          }
                          else
                          {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,index)
                              {
                                return Comment_Card(postid: widget.postid, snapshot: snapshot.data!.docs[index].data(),);
                              },
                            );
                          }
                        },
                      ),
            ),
            Container(
              // constraints: BoxConstraints(
              //     minHeight: 60,
              //     maxHeight: 100
              // ),
              // height: 60,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photourl),),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        controller: comment,
                        decoration: const InputDecoration(
                            hintText: "Write a comment...",
                            border: InputBorder.none
                        ),),
                    ),
                    InkWell(
                      onTap: ()
                      async{
                        String res=await Post_firebase().post_comment(post_uid: widget.postid, username: user.username, desc: comment.text, profImage: user.photourl);
                        if(res=="Sucess")
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("POSTED"),));
                          comment.clear();
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FAILED"),));
                        }
                      },
                      child: Text("POST", style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // body: CustomScrollView(
      //   slivers: [
      //     SliverFillRemaining(
      //       child: StreamBuilder(
      //         stream: FirebaseFirestore.instance.collection('post').doc(widget.postid).collection('comment').orderBy("date_time").snapshots(),
      //         builder: (context ,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
      //         {
      //           if (snapshot.connectionState==ConnectionState.waiting)
      //           {
      //             return CircularProgressIndicator();
      //           }
      //           else
      //           {
      //             return ListView.builder(
      //               itemCount: snapshot.data!.docs.length,
      //               itemBuilder: (context,index)
      //               {
      //                 return Comment_Card(postid: widget.postid, snapshot: snapshot.data!.docs[index].data(),);
      //               },
      //             );
      //           }
      //         },
      //       ),
      //     )
      //   ],
      // ),

      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //     CustomScrollView(
      //       shrinkWrap: true,
      //       slivers: [
      //         SliverFillRemaining(
      //           child: StreamBuilder(
      //             stream: FirebaseFirestore.instance.collection('post').doc(widget.postid).collection('comment').orderBy("date_time").snapshots(),
      //             builder: (context ,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
      //             {
      //               if (snapshot.connectionState==ConnectionState.waiting)
      //               {
      //                 return CircularProgressIndicator();
      //               }
      //               else
      //               {
      //                 return ListView.builder(
      //                   itemCount: snapshot.data!.docs.length,
      //                   itemBuilder: (context,index)
      //                   {
      //                     return Comment_Card(postid: widget.postid, snapshot: snapshot.data!.docs[index].data(),);
      //                   },
      //                 );
      //               }
      //             },
      //           ),
      //         )
      //       ],
      //     ),
      //
      //       Container(
      //         constraints: BoxConstraints(
      //             minHeight: 60,
      //             maxHeight: 100
      //         ),
      //         // height: 60,
      //         child: Padding(
      //           padding: EdgeInsets.all(10),
      //           child: Row(
      //             children: [
      //               CircleAvatar(backgroundImage: NetworkImage(user.photourl),),
      //               SizedBox(width: 20,),
      //               Expanded(
      //                 child: TextField(
      //                   controller: comment,
      //                   decoration: const InputDecoration(
      //                       hintText: "Write a comment...",
      //                       border: InputBorder.none
      //                   ),),
      //               ),
      //               InkWell(
      //                 onTap: ()
      //                 async{
      //                   String res=await Post_firebase().post_comment(post_uid: widget.postid, username: user.username, desc: comment.text, profImage: user.photourl);
      //                   if(res=="Sucess")
      //                   {
      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("POSTED"),));
      //                     comment.clear();
      //                   }
      //                   else
      //                   {
      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FAILED"),));
      //                   }
      //                 },
      //                 child: Text("POST", style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      // bottomNavigationBar: Container(
      //   constraints: BoxConstraints(
      //     minHeight: 60,
      //     maxHeight: 100
      //   ),
      //   // height: 60,
      //   child: Padding(
      //     padding: EdgeInsets.all(10),
      //     child: Row(
      //       children: [
      //         CircleAvatar(backgroundImage: NetworkImage(user.photourl),),
      //         SizedBox(width: 20,),
      //         Expanded(
      //           child: TextField(
      //             controller: comment,
      //             decoration: const InputDecoration(
      //             hintText: "Write a comment...",
      //             border: InputBorder.none
      //           ),),
      //         ),
      //         InkWell(
      //           onTap: ()
      //           async{
      //             String res=await Post_firebase().post_comment(post_uid: widget.postid, username: user.username, desc: comment.text, profImage: user.photourl);
      //             if(res=="Sucess")
      //               {
      //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("POSTED"),));
      //                 comment.clear();
      //               }
      //             else
      //               {
      //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("FAILED"),));
      //               }
      //             },
      //           child: Text("POST", style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// class _BottomNavigationBarDelegate extends SliverPersistentHeaderDelegate {
//   _BottomNavigationBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });
//
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//
//   @override
//   double get minExtent => minHeight;
//
//   @override
//   double get maxExtent => maxHeight;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }
//
//   @override
//   bool shouldRebuild(_BottomNavigationBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }

