import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/firebase/login/image_picker.dart';
import 'package:instagram_clone/firebase/post/post_firebase.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:provider/provider.dart';

class Add_post extends StatefulWidget {
  const Add_post({Key? key}) : super(key: key);

  @override
  State<Add_post> createState() => _Add_postState();
}

class _Add_postState extends State<Add_post> {
  Uint8List? _file;
  TextEditingController _desc=TextEditingController();
  bool _Loading=false;

  postImage(
  {
    required Uint8List image_file,
    required String username,
    required String description,
    required String uid,
    required String profImage
  }
      )
  async {
    Future<String> res=  Post_firebase().post_to_firebase(image_file: image_file, username: username, description: description, uid: uid, likes: [], profImage: profImage);
    setState(() {
      _Loading=true;
    });

    if (res=="Sucess")
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SUCESS"),));
        setState(() {
          _Loading=false;
          _file=null;
        });
      }
    else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SUCESS"),));
        setState(() {
          _Loading=false;
          _file=null;
        });
      }

  }


  select_image(BuildContext context)
  {
    showDialog(context: context,
               builder: (context)
               {
                 return SimpleDialog(
                   title: Text("Create post"),
                   children: [
                     SimpleDialogOption(
                       padding: EdgeInsets.all(20),
                       child: Text("Camera"),
                       onPressed: () async {
                         Navigator.of(context).pop();
                         Uint8List file= await pickImage(ImageSource.camera);
                         setState(() {
                           _file=file;
                         });
                       },
                     ),

                     SimpleDialogOption(
                       padding: EdgeInsets.all(20),
                       child: Text("Gallery"),
                       onPressed: () async {
                         Navigator.of(context).pop();
                         Uint8List file= await pickImage(ImageSource.gallery);
                         setState(() {
                           _file=file;
                         });
                       },
                     ),

                   ],
                 );
               });

  }




  @override
  Widget build(BuildContext context) {

    User user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        leading: Icon(Icons.arrow_back),
        title: Text("Post to"),
        actions: [TextButton(onPressed: (){  postImage(image_file: _file!, username: user.username, description: _desc.text, uid: user.uid, profImage: user.photourl);  },
            child: Text("POST"))
        ],
      ),

      body: _file==null? Center(
        child: IconButton(icon: Icon(Icons.upload),
                          onPressed: () {select_image(context);},),
      ) :
      Column(
        children: [ _Loading?LinearProgressIndicator():
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photourl)
                  //NetworkImage("https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?cs=srgb&dl=pexels-miguel-%C3%A1-padri%C3%B1%C3%A1n-255379.jpg&fm=jpg"),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: TextField(
                    controller: _desc,
                    decoration: InputDecoration(
                        hintText: "Write a caption....",
                        border: InputBorder.none
                    ),
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: AspectRatio(
                    aspectRatio: 487/451,
                    child: Container(
                      decoration: BoxDecoration(image: DecorationImage(
                        image: MemoryImage(_file!),
                        //NetworkImage("https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?cs=srgb&dl=pexels-miguel-%C3%A1-padri%C3%B1%C3%A1n-255379.jpg&fm=jpg"),
                          fit: BoxFit.fill)),

                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
