import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';
import 'LoginView.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';
import 'Signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Check if the user is logged in or not using SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        primaryColor: Color(0xfffe7c96),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage() : SplashScreen(),
    );
  }
}



