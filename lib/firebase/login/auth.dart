import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/login/image_storage.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/screens/signup.dart';

class Auth{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser=_auth.currentUser!;

    DocumentSnapshot snap=await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnapshot(snap);
  }

  Future<String> signUpUser({
  required String email,
  required String pass,
  required String username,
  required String bio,
  required Uint8List file,
  })
  async {
    String result="Error";
    try
    {
      if(email.isNotEmpty || pass.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file!=null)
        {
          //register user
          UserCredential cred= await _auth.createUserWithEmailAndPassword(email: email, password: pass);

          String download_link=await image_storage().upload_image("profile_pic", file, false);

          model.User user=model.User(email: email, pass: pass, username: username, bio: bio, photourl: download_link, followers: [], following: [],uid:cred.user!.uid);

          //add user to database
          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
          result="Sucess";
        }
    }
    catch(err)
    {
      result=err.toString();
    }
    // if (result=="Sucess")
    //   {
    //     ScaffoldMessenger.of(Auth() as BuildContext).showSnackBar(SnackBar(content: Text("SUCESS")));
    //   }

    return result;
  }

  Future<String> login_with_user({
    required String email,
    required String pass
})
  async {
    String result="error";
    try
    {
      if(email.isNotEmpty && pass.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        result="Sucess";
      }
    }
    catch(err)
    {
      result=err.toString();
    }
    return result;
  }


}