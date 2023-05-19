import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/firebase/login/image_storage.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:uuid/uuid.dart';

class Post_firebase
{

  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<String>post_to_firebase(
  {
    required Uint8List image_file,
    required String username,
    required String description,
    required String uid,
    required List likes,
    required String profImage,
}
      )
  async{
    String res="some error";

    try
    {
      String downlond_link=await image_storage().upload_image('post', image_file , true);

      String postId=Uuid().v1();

      Post post =Post(pofImage: profImage,username: username, description: description, uid: uid, datePublish: DateTime.now(), postUrl: downlond_link, likes: likes, postId: postId);

      await _firestore.collection('post').doc(postId).set(post.toJson());
      res="Sucess";
    }
    catch(e)
    {
      res=e.toString();
    }
    return res;


  }

  Future<void>Fav_add({
    required String uid,
    required List fav,
    required String postid,
 })
  async {

    try{
      if (fav.contains(uid))
        {
          await _firestore.collection('post').doc(postid).update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        }
      else
        {
          await _firestore.collection('post').doc(postid).update({
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
    }
    catch(e)
    {
      print(e.toString());
    }


  }

  Future<String>post_comment(
  {
    required String post_uid,
    required String username,
    required String desc,
    required String profImage

  })
  async {
    String res="Error";
    String comment_id=Uuid().v1();
    try{
      await _firestore.collection('post').doc(post_uid).collection('comment').doc(comment_id).set(
          {
            'post_uid':post_uid,
            'username':username,
            'desc':desc,
            'profile_image':profImage,
            'date_time':DateTime.now(),
            'comment_id':comment_id
          });
      res="Sucess";
    }

    catch(e)
    {
      res=e.toString();
    }
    return res;
  }

  Future<String>follow_unfollow({
    required String uid,
    required List follow,
    required List followers
  })
  async {
    String current_user_uid = FirebaseAuth.instance.currentUser!.uid;
    String result="";
    try{
      if (follow.contains(current_user_uid))
      {
        await _firestore.collection('users').doc(current_user_uid).update({
          'following': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });

        result="Remove";
      }

      else
      {
        await _firestore.collection('users').doc(current_user_uid).update({
          'following': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });


        result="Add";
      }

    }
    catch(e)
    {
      print(e.toString());
    }

    return result;

  }


}