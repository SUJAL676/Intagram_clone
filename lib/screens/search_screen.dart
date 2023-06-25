import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  bool _isbool=false;
  TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Expanded(
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: Colors.white12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(top: 11.6,left: 10,right: 10),
                    child: Icon(Icons.search)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter username"
                    ),
                    onSubmitted: (String _)
                    {
                      setState(() {
                        _isbool=true;
                      });
                    }
                    ,
                  ),
                )
              ],
            ),
          ),
        )
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> Profile_Screen(photourl: (snapshot.data! as dynamic).docs[index]['image'],
                              desc: (snapshot.data! as dynamic).docs[index]['bio'],
                              username: (snapshot.data! as dynamic).docs[index]['username'],
                              uid: (snapshot.data! as dynamic).docs[index]['uid'],
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