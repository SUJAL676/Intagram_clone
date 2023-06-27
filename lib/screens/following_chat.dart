import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/post/post_firebase.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/widget/following_chat_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';

class Following_chat extends StatefulWidget {
  final DocumentSnapshot snap;
  const Following_chat({super.key, required this.snap});

  @override
  State<Following_chat> createState() => _Following_chatState();
}


TextEditingController controller1=TextEditingController();
FocusNode focusNode=FocusNode();

class _Following_chatState extends State<Following_chat> {

  @override
  void initState() {
    controller1=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _size=MediaQuery.of(context).size;
    var _height=_size.height;
    var width=_size.width;
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        // leading: Icon(Icons.arrow_back),
        title: Container(
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.snap["image"]),maxRadius: 18,),
              SizedBox(width: 20,),
              Text(widget.snap["username"])
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: _height * 0.75,
              child: stream(snap: widget.snap, user: user)
            ),
            Container(
              padding: const EdgeInsets.only(left: 6,top: 5,right: 6,bottom: 30),
              child: send_area(photo: user.photourl, user: user, snap: widget.snap)
            )


          ],
        ),
      )

      // body: Stack(
      //   children: [
      //     Container(
      //       margin: const EdgeInsets.only(bottom: 73),
      //       child: stream(),
      //     ),
      //
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Container(
      //         margin: const EdgeInsets.all(5),
      //         child: Row(
      //           children: [
      //             const SizedBox(width: 10,),
      //             CircleAvatar(backgroundImage: NetworkImage(user.photourl),),
      //             const SizedBox(width: 15,),
      //             Expanded(
      //               child: TextField(
      //                 controller: controller1,
      //                 decoration: InputDecoration(
      //                     border: InputBorder.none,
      //                     hintText: "Message..."
      //                 ),
      //               ),
      //             ),
      //             IconButton(onPressed: (){},
      //                 icon: Icon(Icons.send))
      //
      //
      //           ],
      //         ),
      //       ),
      //     )
      //
      //   ],
      // ),
    );
  }

  send_area ({required String photo , required User user , required DocumentSnapshot snap })
  {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white10
      ),
      child: Row(
        children: [
          const SizedBox(width: 10,),
          CircleAvatar(backgroundImage: NetworkImage(photo),),
          const SizedBox(width: 15,),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                focusNode: focusNode,
                controller: controller1,
                maxLines: 20,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Message..."
                ),
              ),
            ),
          ),
          IconButton(onPressed: () async {
            String a=await Post_firebase().send_chat(
                message: controller1.text,
                sender_name: user.username,
                sender_id: user.uid,
                receiver_name: snap["username"],
                receiver_id: snap["uid"]);

            if(a=="Sucess")
            {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Send")));
              focusNode.unfocus();
              controller1.clear();
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
              controller1.clear();
            }
          },
              icon: Icon(Icons.send))


        ],
      ),
    );
  }
}

stream({required DocumentSnapshot snap , required User user})
{
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection(snap["uid"]).orderBy("date").snapshots(),
    builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
    {
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return Center(child: CircularProgressIndicator());
      }
      else
      {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index)
          {
            if (snapshot.data!.docs[index]["sender_id"]==user.uid)
              {
                return Align(
                    alignment: Alignment.centerRight,
                    child: Following_Chat_Card(snap: snapshot.data!.docs[index], isreceiver: false,)
                );
              }
            else
              {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: Following_Chat_Card(snap: snapshot.data!.docs[index], isreceiver: true,)
                );
              }
          },
        );
      }
    },
  );
}


