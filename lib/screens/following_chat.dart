import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          children: [
            Container(
              height: 700,
              child: Expanded(
                child: stream(),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 6,top: 5,right: 6),
              child: Container(
                height: 55,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.white10
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    CircleAvatar(backgroundImage: NetworkImage(user.photourl),),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        controller: controller1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message..."
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){},
                        icon: Icon(Icons.send))


                  ],
                ),
              ),
            )


          ],
        ),
      )
    );
  }
}

stream()
{
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
              return Following_Chat_Card();
            },
          );
        }
    },
  );
}
