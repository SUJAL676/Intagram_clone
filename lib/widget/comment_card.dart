import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment_Card extends StatefulWidget {
  final String postid;
  final snapshot;
  const Comment_Card({Key? key, required this.postid, required this.snapshot}) : super(key: key);

  @override
  State<Comment_Card> createState() => _Comment_CardState();
}

class _Comment_CardState extends State<Comment_Card>
{


  @override
  Widget build(BuildContext context)
  {
   DateTime dateTime=widget.snapshot['date_time'].toDate();
   String formatted_date=DateFormat('dd/MM/yy').format(dateTime);

    return Container
      (
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
              Text(formatted_date),
              SizedBox(height: 25,)
            ],
          )

        ],
      ) ,
    );
  }
}
