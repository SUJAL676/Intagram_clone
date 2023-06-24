
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/firebase/login/auth.dart';
import 'package:instagram_clone/models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final Auth _auth=Auth();

  User get getUser => _user ?? User(email: '', pass: '', username: '', bio: '', photourl: '', followers: [], following: [], uid: '');

  Future<void> refreshUser() async
  {
    User user= await _auth.getUserDetails();
    _user=user;
    notifyListeners();
  }
}