import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';
import 'LoginView.dart';
import 'firebase_options.dart';
import 'Signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  Signup()),
      );
    });
  }
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('loggedIn') ?? false;
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/splashLogo.png',
              height:330,
              width:330,
            ),
            SizedBox(height:36),
            Text(
              'FRIDGE CONNECT',
              style:GoogleFonts.poppins(
                  color:Color(0xff232323),
                  fontSize:25,fontWeight: FontWeight.bold),),
            Text(
              'Intelligent Solution For Your Fridge',
              style:GoogleFonts.poppins(
                  color:Color(0xff232323),
                  fontSize:12,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}