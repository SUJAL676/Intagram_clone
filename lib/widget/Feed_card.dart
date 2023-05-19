import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post/post_firebase.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../screens/comment_post.dart';

class Feed_Card extends StatelessWidget {
  final snap;
  const Feed_Card({Key? key,required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user=Provider.of<UserProvider>(context).getUser;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15,left: 10,bottom: 10),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(snap['profile_Image']),
                radius: 18,),
                const SizedBox(width: 10,),
                Text(snap['username'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: (){

                    }, icon: Icon(Icons.more_vert)),
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image(image: NetworkImage(snap['postUrl']),
              fit: BoxFit.fill,),
          ),

          Row(
            children: [
              IconButton(onPressed: (){
                Post_firebase().Fav_add(uid: user.uid, fav: snap['likes'], postid: snap['postid']);
              },
                  icon: snap['likes'].contains(user.uid)? Icon(Icons.favorite_rounded,color:Colors.red)  : Icon(Icons.favorite_border)),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Comment_Post(postid: snap['postid'])));
              }, icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.send)),

              Expanded(child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(onPressed: (){},icon: Icon(Icons.bookmark_border_outlined),),
              ))
            ],
          ),

          Padding(padding: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("${snap['likes'].length.toString()} likes",style: TextStyle(fontSize: 14),),
              SizedBox(height: 8,),
              Row(
                  children:[ Text(snap['username'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                             SizedBox(width: 10,),
                             Text(snap['description']),
                  ]),

              SizedBox(height: 5,),

              Text("View all 200 comments",style: TextStyle(color: Colors.grey,fontSize: 14,))
            ],
          ),),

        ],
      ),
    );
  }
}
