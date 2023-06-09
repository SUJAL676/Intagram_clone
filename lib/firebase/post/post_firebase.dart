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
    var user_snap=await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List user_followers=user_snap['followers'];

    String result="";
    try{
      if (user_followers.contains(current_user_uid))
      {
        await _firestore.collection('users').doc(current_user_uid).update({
          'following': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });

        return result="Removed";
      }

      else
      {
        await _firestore.collection('users').doc(current_user_uid).update({
          'following': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });


        return result="Followed";
      }

    }
    catch(e)
    {
      result=e.toString();
    }

    return result;

  }

  Future<String> send_chat(
  {
    required String message,
    required String sender_name,
    required String sender_id,
    required String receiver_name,
    required String receiver_id,
  }
      )
  async {
    String result="";
    String message_id=Uuid().v1();
    try
    {
      await _firestore.collection('users').doc(sender_id).collection(receiver_id).doc(message_id).set(
        {
          "message" : message,
          "message_id": message_id,
          "sender": sender_name,
          "sender_id": sender_id,
          "date": DateTime.now(),
          "receiver_name":receiver_name,
          "recceiver_id": receiver_id
        });

      await _firestore.collection('users').doc(receiver_id).collection(sender_id).doc(message_id).set(
          {
            "message" : message,
            "message_id": message_id,
            "sender": sender_name,
            "sender_id": sender_id,
            "date": DateTime.now(),
            "receiver_name":receiver_name,
            "recceiver_id": receiver_id
          });
      result="Sucess";
    }
    catch(e)
    {
      result=e.toString();
    }
    return result;
  }


}