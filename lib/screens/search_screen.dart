import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

import '../responses/android.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

TextEditingController controller =TextEditingController();

class _Search_ScreenState extends State<Search_Screen> {

  @override
  void initState() {
    super.initState();
    controller=TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _isbool=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 140,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: mobileBackgroundColor,
      //   centerTitle: false,
      //   title: Expanded(
      //     child: Container(
      //       height: 40,
      //       width: double.infinity,
      //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: Colors.white12),
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           Padding(padding: EdgeInsets.only(top: 11.6,left: 10,right: 10),
      //               child: Icon(Icons.search)),
      //           Expanded(
      //             child: TextField(
      //               controller: controller,
      //               decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   hintText: "Enter username"
      //               ),
      //               onSubmitted: (String _)
      //               {
      //                 setState(() {
      //                   _isbool=true;
      //                 });
      //               }
      //               ,
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   )
      // ),

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
                        child:  Text("Search",style: TextStyle(fontSize: 25),)),
                  ],
                ),
                SizedBox(height: 20,),
                search()
              ],
            ),
          ),
        ),

      body:_isbool?FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isEqualTo: controller.text).get(),
        builder: (context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              CircularProgressIndicator();
            }
          else
            {
              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context , index)
                  {
                    return InkWell(
                      onTap: (){
                        controller.clear();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> Profile_Screen(photourl: (snapshot.data! as dynamic).docs[index]['image'],
                              desc: (snapshot.data! as dynamic).docs[index]['bio'],
                              username: (snapshot.data! as dynamic).docs[index]['username'],
                              uid: (snapshot.data! as dynamic).docs[index]['uid'], isback: true,
                              // followers: (snapshot.data! as dynamic).docs[index]['followers'],
                              // following: (snapshot.data! as dynamic).docs[index]['following'],
                            )) );
                      },
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['image']),),
                        title: Text((snapshot.data! as dynamic).docs[index]['username']),
                      ),
                    );
                  }
              );
            }
          return Center();
        } ,
      ) : post_display()

      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       Container(
      //         margin: EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
      //         height: 50,
      //         width: double.infinity,
      //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: Colors.white12),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Padding(padding: EdgeInsets.only(top: 11.6,left: 10,right: 10),
      //                 child: Icon(Icons.search)),
      //             Expanded(
      //               child: TextField(
      //                 controller: controller,
      //                 decoration: InputDecoration(
      //                     border: InputBorder.none,
      //                     hintText: "Enter username"
      //                 ),
      //                 onSubmitted: (String _)
      //                 {
      //                   setState(() {
      //                     _isbool=true;
      //                   });
      //                 }
      //                 ,
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //
      //       Container(
      //         child: _isbool?FutureBuilder(
      //             future: FirebaseFirestore.instance.collection('users').where('username',isEqualTo: controller.text).get(),
      //             builder: (context,snapshot)
      //             {
      //               if(snapshot.connectionState==ConnectionState.waiting)
      //                 {
      //                   CircularProgressIndicator();
      //                 }
      //               else
      //                 {
      //                   return ListView.builder(
      //                       itemCount: (snapshot.data! as dynamic).docs.length,
      //                       itemBuilder: (context , index)
      //                       {
      //                         return InkWell(
      //                           onTap: (){
      //                             Navigator.of(context).push(MaterialPageRoute(
      //                                 builder: (context)=> Profile_Screen(photourl: (snapshot.data! as dynamic).docs[index]['image'],
      //                                   desc: (snapshot.data! as dynamic).docs[index]['bio'],
      //                                   username: (snapshot.data! as dynamic).docs[index]['username'],
      //                                   uid: (snapshot.data! as dynamic).docs[index]['uid'], isback: true,
      //                                   // followers: (snapshot.data! as dynamic).docs[index]['followers'],
      //                                   // following: (snapshot.data! as dynamic).docs[index]['following'],
      //                                 )) );
      //                           },
      //                           child: ListTile(
      //                             leading: CircleAvatar(backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['image']),),
      //                             title: Text((snapshot.data! as dynamic).docs[index]['username']),
      //                           ),
      //                         );
      //                       }
      //                   );
      //                 }
      //               return Center();
      //             } ,
      //           ) : post_display(),
      //       )
      //     ],
      //   ),
      // ),



    );

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
                      border: InputBorder.none, hintText: "Enter username"),
                  onSubmitted: (String _) {
                    setState(() {
                      _isbool = true;
                    });
                  }))
        ],
      ),
    );
  }
}

Container post_display()
{
  return Container(
    margin: EdgeInsets.only(top:15),
    child: FutureBuilder(
      future: FirebaseFirestore.instance.collection('post').get(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData)
          {
            return Center(child: CircularProgressIndicator(),);
          }

        return StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index)=>Image(image: NetworkImage((snapshot.data! as dynamic).docs[index]['postUrl']),)
            ,
            staggeredTileBuilder: (index) =>StaggeredTile.count(
              (index %7 ==0)?2:1,
              (index%7 ==0)?2:1
          )
        );
      },
    ),
  );
}

// search()
// {
//   return Container(
//     //margin: EdgeInsets.only(right: 7, left: 2),
//     width: double.infinity,
//     height: 50,
//     decoration: BoxDecoration(
//       color: Colors.white12,
//       borderRadius: BorderRadius.all(Radius.circular(10)),
//     ),
//
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Padding(
//             padding: EdgeInsets.only(top: 13, left: 10, right: 10),
//             child: Icon(Icons.search)),
//         Expanded(
//           child: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Enter username"
//             ),
//               onSubmitted: (String _)
//                           {
//                             setState(() {
//                               _isbool=true;
//                             });
//           )
//
//         )
//       ],
//     ),
//   );
//}