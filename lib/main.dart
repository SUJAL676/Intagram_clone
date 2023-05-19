import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/responses/android.dart';
import 'package:instagram_clone/responses/responsive.dart';
import 'package:instagram_clone/responses/web.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/screens/login.dart';
import 'package:instagram_clone/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/provider/user_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();



  if (kIsWeb)
    {
      await Firebase.initializeApp(
        options: const FirebaseOptions(apiKey: "AIzaSyCijDPl9K178NewhaG-vUz_rM1gQ9ggi5Y" , appId: "1:34562839100:web:cb6cec0d1149fa82f36939", messagingSenderId: "34562839100", projectId: "instaclone-27f37",storageBucket: "instaclone-27f37.appspot.com")
      );
    }
  
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const responsive_layout(Android: android(),Web: web(),),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot)
          {
            if(snapshot.connectionState== ConnectionState.active)
              {
                if(snapshot.hasData)
                  {
                    return const responsive_layout(Android: android(), Web: web());
                  }
                else if(snapshot.hasError)
                {
                  return Center(child: Text("${snapshot.error}"),);
                }
              }
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ),);
              }
            return login();
          },
        ),
      ),
    );
  }
}

