import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/color.dart';

class Following_chat extends StatefulWidget {
  final   DocumentSnapshot snap;
  const Following_chat({super.key, required this.snap});

  @override
  State<Following_chat> createState() => _Following_chatState();
}

class _Following_chatState extends State<Following_chat> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
