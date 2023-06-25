import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';
import '../widget/Feed_card.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

TextEditingController controller=TextEditingController();

class _ChatState extends State<Chat> {


  @override
  void initState() {
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider
        .of<UserProvider>(context)
        .getUser;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: Text(user.uid, style: TextStyle(color: Colors.white),),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:
            [
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 1, left: 10, right: 10),
                        child: Icon(Icons.search)),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter username"
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('post').snapshots(),
                builder: (context ,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot)
                {
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index)
                      {
                        return Feed_Card(snap: snapshot.data!.docs[index].data());
                      },
                    );
                  }
                },
              ),
            ]
        )
    );
  }


//   search() {
//     return ;
//   }
}