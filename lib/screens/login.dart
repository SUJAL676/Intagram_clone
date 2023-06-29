import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/widget/edit_text_field.dart';
import 'package:instagram_clone/firebase/login/auth.dart';
import 'package:instagram_clone/screens/signup.dart';

import '../responses/android.dart';
import '../responses/responsive.dart';
import '../responses/web.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  final TextEditingController email=TextEditingController();
  final TextEditingController pass=TextEditingController();
  bool _isloading=false;

  @override
  void dispose()
  {
    super.dispose();
    email.dispose();
    pass.dispose();
  }

  Future<void> login_on_tap()
  async {
    setState(() {
      _isloading=true;
    });

    String re= await Auth().login_with_user(email: email.text, pass: pass.text);

    if(re!="Sucess")
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(re.toString())));

    }
    else
      {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => responsive_layout(Android: android(), Web: web()) )
        );
      }
    setState(() {
      _isloading=false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(child: Center(
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 32,),
      //       height: MediaQuery.of(context).size.height,
      //       width: double.infinity,
      //       child: SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             SizedBox(height: 30),
      //             SvgPicture.asset("assets/images/ic_instagram.svg",color: primaryColor,
      //             height: 64,),
      //             const SizedBox(height: 50,),
      //             Edit_text_field(controller: email, hint_text: "Enter email", type: TextInputType.emailAddress),
      //             const SizedBox(height: 25,),
      //             Edit_text_field(controller: pass, hint_text: "Enter pass", type: TextInputType.text,ispass: true,),
      //             const SizedBox(height: 25,),
      //             InkWell(
      //               onTap: () => login_on_tap(),
      //               child: Container(
      //                 child:_isloading? Center(child: CircularProgressIndicator(color: Colors.white,),) :
      //                 const Text("Log in"),
      //                 width: double.infinity,
      //                 height: 40,
      //                 alignment: Alignment.center,
      //                 decoration: const ShapeDecoration(
      //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
      //                     ,color: Colors.blue
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // )),

      body: LayoutBuilder(builder: (BuildContext context , BoxConstraints constraint)
        {
          return Container(
            width: constraint.maxWidth,
            height: constraint.maxHeight,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    SvgPicture.asset("assets/images/ic_instagram.svg",color: primaryColor,
                    height: 64,),
                    const SizedBox(height: 50,),
                    Edit_text_field(controller: email, hint_text: "Enter email", type: TextInputType.emailAddress),
                    const SizedBox(height: 25,),
                    Edit_text_field(controller: pass, hint_text: "Enter pass", type: TextInputType.text,ispass: true,),
                    const SizedBox(height: 25,),
                    InkWell(
                      onTap: () => login_on_tap(),
                      child: Container(
                        child:_isloading? Center(child: CircularProgressIndicator(color: Colors.white,),) :
                        const Text("Log in"),
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                            ,color: Colors.blue
                        ),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
                ),
            );
        },),

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?"),
            InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) =>signup() )
                  );
                },
                child: Text("Signup",style: TextStyle(fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }
}



