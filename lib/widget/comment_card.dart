import 'package:flutter/material.dart';

class Comment_Card extends StatefulWidget {
  final String postid;
  final snapshot;
  const Comment_Card({Key? key, required this.postid, required this.snapshot}) : super(key: key);

  @override
  State<Comment_Card> createState() => _Comment_CardState();
}

class _Comment_CardState extends State<Comment_Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.snapshot['profile_image']),),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.snapshot['username'],style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text(widget.snapshot['desc']),
                ],),
              SizedBox(height: 3,),
              Text("11/04/23"),
              SizedBox(height: 25,)
            ],
          )

        ],
      ) ,
    );
  }
}
