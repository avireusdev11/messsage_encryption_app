import 'package:enc/message_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'change.dart';
import 'login.dart';
import 'first_page.dart';
import 'profile_page.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>First_page(),
        '/reg':(context)=>Signup(),
        '/profile':(context)=>Profile(),
        '/login':(context)=>Login(),
        '/message_page':(context)=>Messages(),
      },
    );
  }
}

