


import 'package:cloud_firestore/cloud_firestore.dart';

class User{
 final String email;
 final String pass;
 final String uid;
 final String username;
 final String bio;
 final String photourl;
 final List followers;
 final List following;

 User({required this.email, required this.pass, required this.username, required this.bio, required this.photourl, required this.followers, required this.following, required this.uid});

 Map<String ,dynamic> toJson() => {
   'username':username,
   'email':email,
   'pass':pass,
   'bio':bio,
   'followers':[],
   'following':[],
   'image':photourl,
   'uid':uid
 };

 static User fromSnapshot(DocumentSnapshot snap)
 {
   var snapshot=snap.data() as Map<String,dynamic>;

   return User(email: snapshot['email'], pass: snapshot['pass'], username: snapshot['username'], bio: snapshot['bio'], photourl: snapshot['image'], followers: snapshot['followers'], following: snapshot['following'], uid: snapshot['uid']);


 }
}
