import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post/post_firebase.dart';
import 'package:instagram_clone/screens/feed_post.dart';
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
  Widget build(BuildContext context) {
    User user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("COMMENTS"),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Feed_Post()) );
        },),
        backgroundColor: mobileBackgroundColor,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').doc(widget.postid).collection('comment').snapshots(),
        builder: (context ,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
        {
          if (snapshot.connectionState==ConnectionState.waiting)
            {
              return CircularProgressIndicator();
            }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index)
            {
              return Comment_Card(postid: widget.postid, snapshot: snapshot.data!.docs[index].data(),);
            },
          );
        },
      ),

      bottomNavigationBar: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: 60,
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
      ),
    );
  }
}
