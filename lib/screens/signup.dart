import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/firebase/login/image_picker.dart';
import 'package:instagram_clone/widget/edit_text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../firebase/login/auth.dart';
import '../responses/android.dart';
import '../responses/responsive.dart';
import '../responses/web.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signup();
}

class _signup extends State<signup> {

  final TextEditingController email=TextEditingController();
  final TextEditingController pass=TextEditingController();
  final TextEditingController user=TextEditingController();
  final TextEditingController bio=TextEditingController();
  Uint8List? image =null;
  bool isloading=false;

  @override
  void dispose()
  {
    super.dispose();
    email.dispose();
    pass.dispose();
    user.dispose();
    bio.dispose();
  }

  void selectImage()async{
    Uint8List im=await pickImage(ImageSource.gallery);
    setState(() {
      image=im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              SvgPicture.asset("assets/images/ic_instagram.svg",color: primaryColor,
                height: 64,),
              const SizedBox(height: 25,),
              Stack(
                children: [
                  image!=null?
                  CircleAvatar(
                    radius: 64,
                    //backgroundColor: drak_grey,
                    backgroundImage: MemoryImage(image!),
                  )

                  :const CircleAvatar(
                    radius: 64,
                    //backgroundColor: drak_grey,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                  ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () =>selectImage(),
                        icon: Icon(Icons.add_a_photo),
                  ))
                ],
              ),

              const SizedBox(height: 25,),
              Edit_text_field(controller: user, hint_text: "Enter your username", type: TextInputType.text,),
              const SizedBox(height: 25,),
              Edit_text_field(controller: email, hint_text: "Enter your email", type: TextInputType.emailAddress),
              const SizedBox(height: 25,),
              Edit_text_field(controller: pass, hint_text: "Enter your pass", type: TextInputType.text,ispass: true,),
              const SizedBox(height: 25,),
              Edit_text_field(controller: bio, hint_text: "Enter your bio", type: TextInputType.text),
              const SizedBox(height: 50,),
              InkWell(
                onTap: ()
                async {

                  if(user.text.isNotEmpty && email.text.isNotEmpty&&pass.text.isNotEmpty&&bio.text.isNotEmpty&& (image != null))
                    {

                      setState(() {
                        isloading=true;
                      });

                      String a=await Auth().signUpUser(email: email.text, pass: pass.text, username: user.text, bio: bio.text, file: image!,);

                      setState(() {
                        isloading=false;
                      });

                      if (a=="Sucess")
                      {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => responsive_layout(Android: android(), Web: web()) )
                        );
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(a.toString())));
                      }
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter each details")));
                    }

                },
                child: Container(
                  child: isloading? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      :const Text("Sign up"),
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                      ,color: Colors.blue
                  ),
                ),
              ),

              const SizedBox(height: 170,),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Don't have an account?"),
              //     InkWell(
              //         onTap: (){},
              //         child: Text("Signup",style: TextStyle(fontWeight: FontWeight.bold),))
              //   ],
              // )

            ],
          ),
        ),
      )),
    );
  }
}



