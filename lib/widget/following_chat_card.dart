import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Following_Chat_Card extends StatefulWidget {
  final DocumentSnapshot snap;
  final bool isreceiver;
  const Following_Chat_Card({super.key, required this.snap, required this.isreceiver});

  @override
  State<Following_Chat_Card> createState() => _Following_Chat_CardState();
}

class _Following_Chat_CardState extends State<Following_Chat_Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        minWidth: 100,
        maxHeight: 1000,
        maxWidth: 300
      ),
      // height: 40,
      // width: 100,
      padding: EdgeInsets.only(top: 11,left: 10,right: 5,bottom: 10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: widget.isreceiver ?
      BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.all(Radius.circular(13),).copyWith(bottomLeft: Radius.zero)
      ) :
      BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(13),).copyWith(bottomRight: Radius.zero)
      ),
      child: Text(widget.snap["message"]),
    );
  }
}
