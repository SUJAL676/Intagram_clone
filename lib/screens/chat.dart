import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/user_provider.dart';

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
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(user.username, style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          search()
        ],
      ),
    );
  }


  search() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(top: 1, left: 10, right: 10),
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
    );
  }

  user( User user) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("user").where("followers" ,arrayContains: user.uid) .get(),
      builder: (context,snap)
      {
        if(snap.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(color: Colors.white12,),);
          }
        else
        {
          return ListView.builder(
            itemCount: (snap.data! as dynamic).docs.lenght,
            itemBuilder: (context,index)
            {
              DocumentSnapshot snaps=(snap.data! as dynamic).docs[index];
              return Text("hi");
            },
          );
        }
      },
    );
  }
}