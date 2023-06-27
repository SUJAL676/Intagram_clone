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
    var size=MediaQuery.of(context).size;
   DateTime dateTime=widget.snapshot['date_time'].toDate();
   String formatted_date=DateFormat('dd/MM/yy').format(dateTime);

    return Container(
      // constraints: BoxConstraints(
      //   minWidth: size.width * 0.5,
      //   maxWidth: size.width * 0.9,
      //   maxHeight: 200,
      //   minHeight: 10,
      // ),
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
              Text("${widget.snapshot['username']}   ${widget.snapshot['desc']}",style: TextStyle(fontWeight: FontWeight.bold),),
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
