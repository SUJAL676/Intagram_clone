import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/feed_post.dart';
import 'package:instagram_clone/screens/messenger.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_screen.dart';
import '../screens/profile_screen.dart';

class android extends StatefulWidget {
  const android({Key? key}) : super(key: key);

  @override
  State<android> createState() => _androidState();
}

class _androidState extends State<android> {
  var _page=0;
  PageController pageController=PageController();

  @override
  void initState() {
    super.initState();
    pageController=PageController();
  }
  @override
  void dispose()
  {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page)
  {
    pageController.jumpToPage(page);
  }

  void onpagechnaged(int page)
  {
    setState(() {
      _page=page;
    });
  }

  // void snaap(
  // {
  //   required String uid
  // }
  //     )
  // {
  //   FutureBuilder(
  //     future: FirebaseFirestore.instance.collection('post').where('uid', isEqualTo: uid).get(),
  //     builder: (context,snapshot)
  //     {
  //       return snapshot.data!.docs.length;
  //     } ,
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    User user=Provider.of<UserProvider>(context).getUser;

    return  Scaffold(
      body: PageView(
        children: [Feed_Post(),
          Search_Screen(),
          Add_post(),
          messenger(),
          Profile_Screen(photourl: user.photourl, username: user.username, desc: user.bio, uid: user.uid, isback: false,),],
          // Text("Profile"),],

      controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onpagechnaged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home ,color: _page==0?primaryColor:secondaryColor,)),
          BottomNavigationBarItem(icon: Icon(Icons.search ,color: _page==1?primaryColor:secondaryColor,),),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_sharp ,color: _page==2?primaryColor:secondaryColor,),),
          BottomNavigationBarItem(icon: Icon(Icons.messenger_outline ,color: _page==3?primaryColor:secondaryColor,),),
          BottomNavigationBarItem(icon: Icon(Icons.person ,color: _page==4?primaryColor:secondaryColor,),),

      ],onTap: navigationTapped,),
    ) ;
  }
}
