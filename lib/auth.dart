// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class AuthService{
//
//
//   final userStream = FirebaseAuth.instance.authStateChanges();
//   final user = FirebaseAuth.instance.currentUser;
//   final _auth = FirebaseAuth.instance;
//
//
//   Future<void> emailLogin(String email, String password , BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
//     }  on FirebaseAuthException catch (e) {
//       var snackBar =
//       SnackBar(content: Text(e.message.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//
//   }
//
//   Future<void> registerUser(String email, String password, BuildContext context) async {
//
//     try {
//       await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     }  on FirebaseAuthException catch (e) {
//       var snackBar =
//       SnackBar(content: Text(e.message.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
//
//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
//
// }