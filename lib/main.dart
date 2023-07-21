import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

  class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
  50: Color.fromRGBO(254, 124, 151, .1),
  100: Color.fromRGBO(254, 124, 151, .2),
  200: Color.fromRGBO(254, 124, 151, .3),
  300: Color.fromRGBO(254, 124, 151, .4),
  400: Color.fromRGBO(254, 124, 151, .5),
  500: Color.fromRGBO(254, 124, 151, .6),
  600: Color.fromRGBO(254, 124, 151, .7),
  700: Color.fromRGBO(254, 124, 151, .8),
  800: Color.fromRGBO(254, 124, 151, .9),
  900: Color.fromRGBO(254, 124, 151, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        primaryColor: Color(0xfffe7c96),
        primarySwatch: MaterialColor(0xfffe7c96, color),
      ),
      home:const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );

  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  Signup()),
      );
    });
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