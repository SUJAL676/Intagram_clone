import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/responses/android.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import 'following_chat.dart';

class messenger extends StatefulWidget {
  const messenger({super.key});

  @override
  State<messenger> createState() => _messengerState();
}

TextEditingController controller=TextEditingController();

class _messengerState extends State<messenger> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:
            [
              SizedBox(height: 4,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4,right: 20),
                      child: InkWell(onTap:() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>android())),
                          child: Icon(Icons.arrow_back , size: 29,))),
                  Container( padding: EdgeInsets.only(top: 3),
                  child:  Text(user.username,style: TextStyle(fontSize: 25),)),
                ],
              ),
              SizedBox(height: 20,),
              search()
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('users').where('followers',arrayContains: user.uid) .get(),
          builder: (context,AsyncSnapshot snap)
          {
            if(snap.connectionState==ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
            else
            {
              return ListView.builder(
                itemCount: (snap.data! as dynamic).docs.length,
                itemBuilder: (context,index)
                {
                  DocumentSnapshot snaps=(snap.data! as dynamic).docs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Following_chat(snap: snaps))),
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(snaps["image"]),),
                        title: Text(snaps["username"] , style: TextStyle(fontSize: 20),),
                        trailing: Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Icon(Icons.messenger_outline)),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

search()
{
  return Container(
    //margin: EdgeInsets.only(right: 7, left: 2),
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
            padding: EdgeInsets.only(top: 13, left: 10, right: 10),
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
