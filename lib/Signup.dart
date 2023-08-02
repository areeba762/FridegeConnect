import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/firestore.dart';

class Signup extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await FirestoreService().createUserDoc();
      // Successful signup
      Fluttertoast.showToast(msg: 'Signup successful');
      // Set the login state to true using shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'Weak password');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email already in use');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/SignupLogo.png',
              height:200,
              width:200,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () => _signup(context),
                      child: Text('Signup',
                        style: TextStyle(color: Colors.white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                    ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginView()),
                        );
                      },
                      child: Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

