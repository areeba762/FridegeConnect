import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class profile_tab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<profile_tab> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          _user = snapshot.data;
          return _user != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Icon(Icons.person, size: 64),
                  radius: 48,
                ),
                SizedBox(height: 16),
                Text('Email: ${_user!.email ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('User ID: ${_user!.uid}'),
              ],
            ),
          )
              : Center(child: Text('User not logged in.'));
        }
      },
    );

  }
}
