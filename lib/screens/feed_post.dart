import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/chat.dart';
import 'package:instagram_clone/screens/messenger.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/widget/Feed_card.dart';

class Feed_Post extends StatefulWidget {
  const Feed_Post({Key? key}) : super(key: key);

  @override
  State<Feed_Post> createState() => _Feed_PostState();
}

class _Feed_PostState extends State<Feed_Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset("assets/images/ic_instagram.svg",color: Colors.white,height: 35,),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>messenger()));
          }, icon: Icon(Icons.messenger_outline))
        ],
      ),
      body: StreamBuilder(
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
    );
  }
}
