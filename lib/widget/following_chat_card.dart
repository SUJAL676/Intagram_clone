import 'package:flutter/material.dart';

class Following_Chat_Card extends StatefulWidget {
  const Following_Chat_Card({super.key});

  @override
  State<Following_Chat_Card> createState() => _Following_Chat_CardState();
}

class _Following_Chat_CardState extends State<Following_Chat_Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(4),)
      ),
      child: Text("hi"),
    );
  }
}