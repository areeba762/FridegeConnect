import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'HomePage.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Successful login
      Fluttertoast.showToast(msg: 'Login successful');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()), // Replace with your home page
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'User not found');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password');
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
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/SignupLogo.png',
              height:200,
              width:200,
            ),
            Padding(
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
                    onPressed: () => _login(context),
                    child: Text('Login',
                        style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement Forgot Password functionality
                      Fluttertoast.showToast(msg: 'Forgot Password');
                    },
                    child: Text('Forgot Password'),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                          PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return FadeTransition(
                            opacity: animation,
                            child: Signup(),
                      );
                      },
                        // MaterialPageRoute(builder: (_) => Signup()),
                      ),
                      );
                    },
                    child: Text('Dont have an account? Signup'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
