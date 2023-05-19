import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String username;
  final String description;
  final String uid;
  final postId;
  final DateTime datePublish;
  final String postUrl;
  final likes;
  final String pofImage;

  Post({required this.pofImage,required this.username, required this.description, required this.uid, required this.postId, required this.datePublish, required this.postUrl,required this.likes});



  Map<String ,dynamic> toJson() => {
    'username':username,
    'description':description,
    'uid':uid,
    'postid':postId,
    'datePublish':datePublish,
    'postUrl':postUrl,
    'likes':likes,
    'profile_Image':pofImage
  };

  // static User fromSnapshot(DocumentSnapshot snap)
  // {
  //   var snapshot=snap.data() as Map<String,dynamic>;
  //
  //   return User(email: snapshot['email'], pass: snapshot['pass'], username: snapshot['username'], bio: snapshot['bio'], photourl: snapshot['image'], followers: snapshot['followers'], following: snapshot['following'], uid: snapshot['uid']);
  //
  //
  // }
}
