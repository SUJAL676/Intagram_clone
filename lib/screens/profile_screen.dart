import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/utils/color.dart';

import '../firebase/post/post_firebase.dart';

class Profile_Screen extends StatefulWidget {
  final String photourl;
  final String username;
  final String desc;
  final String uid;

  const Profile_Screen({Key? key, required this.photourl, required this.username, required this.desc, required this.uid,}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {

  bool is_true=true;
  @override
  void initState() {
    super.initState();
    get_data();
    setState(() {
      is_true=false;
    });
  }

  int a=0;
  List Following=[];
  List Followers=[];

  void get_data()
  async{
    var b=await FirebaseFirestore.instance.collection('post').where('uid',isEqualTo: widget.uid).get();
    var snap=await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    setState(() {
      a=b.docs.length;
      Following=snap['following'];
      Followers=snap['followers'];
    });
  }


  @override
  Widget build(BuildContext context) {
    bool follow_unfollow=Followers.contains(FirebaseAuth.instance.currentUser!.uid)?true:false;
    var followers_lenght=Followers.length;
    var following_lenght=Following.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.username.toUpperCase()),
        backgroundColor: mobileBackgroundColor,
      ),

      body:is_true? Center(child: CircularProgressIndicator(),)
          :Container(
        padding: EdgeInsets.only(left: 15,top: 15,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                CircleAvatar(backgroundImage: NetworkImage(widget.photourl),
                radius: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        column(number: a.toString(), text: "posts"),
                        column(number: followers_lenght.toString(), text: "followers"),
                        column(number: following_lenght.toString(), text: "following"),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        widget.uid == FirebaseAuth.instance.currentUser!.uid ? InkWell(
                                                                               onTap: (){},
                                                                               child: Container(
                                                                                      height: 30,
                                                                                      width: 250,
                                                                                       decoration: BoxDecoration(
                                                                                                       border: Border.all(
                                                                                                               color: Colors.white,
                                                                                                               width: 1.5),
                                                                                                       borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                                       color: Colors.black,
                                                                                                      ),

                                                                                       child: const Center(child: Text("Edit Profile"),),),
                        )
                                                                             :follow_unfollow? InkWell(
                                                                               onTap: (){
                                                                                 Post_firebase().follow_unfollow(
                                                                                     uid: widget.uid, follow: Following, followers: Followers);

                                                                                 setState(() => get_data());

                                                                                 ScaffoldMessenger.of(context).showSnackBar(
                                                                                   SnackBar(content: Text("OPPS"))
                                                                                 );
                                                                               },
                                                                               child: Container(
                                                                                       height: 30,
                                                                                       width: 250,


                                                                                       decoration: const BoxDecoration(
                                                                                             borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                             color: Colors.blue,),

                                                                                       // child: widget.followers.contains(FirebaseAuth.instance.currentUser!.uid)?
                                                                                       // const Center(child: Text("Following" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),)
                                                                                       // : const Center(child: Text("Follow" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                                                                                       child: Center(child: Text("Following",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                                                                               ),
                                                                             ) :
                        InkWell(
                          onTap: (){
                            Post_firebase().follow_unfollow(
                                uid: widget.uid, follow: Following, followers: Followers);

                            setState(() => get_data());
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("OPPS"))
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 250,


                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.blue,),

                            // child: widget.followers.contains(FirebaseAuth.instance.currentUser!.uid)?
                            // const Center(child: Text("Following" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),)
                            // : const Center(child: Text("Follow" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                            child: Center(child: Text("Follow",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                          ),
                        )


                      ],
                    )

                  ],
                )


              ],
            ),

            const SizedBox(height: 20,),
            Text(" ${widget.username.toUpperCase()}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 3,),
            Text("  ${widget.desc}"),
            const SizedBox(height: 5,),

            const Divider(thickness: 2,),

            FutureBuilder(
              future: FirebaseFirestore.instance.collection('post').where('uid',isEqualTo: widget.uid).get(),
              builder: (context ,snapshot)
              {
                if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    Center(child: CircularProgressIndicator());
                  }
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1
                    ),
                    itemBuilder: (context,index)
                {
                  DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                });

              },
            )


          ],
        ),
      ),
    );
  }
}

Container column({required String number , required String text})
{
  return Container(
    margin: EdgeInsets.only(left: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(number ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 ,),),
        Text(text,style: TextStyle(fontSize: 15),)
      ],
    ),
  );
}
