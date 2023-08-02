import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_items_tab.dart'; // Import the fridge_items_tab.dart file

class Home_tab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<Home_tab> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Fetch the current user when the widget is initialized
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // User not logged in, show a login button or something else
      return Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Login'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('fridge_items')
            .where('userId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> items = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Show the fridge items when the fridge image is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => fridge_items_tab(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'images/fridge.png', // Path to the fridge image asset
                    width: 400,
                    height: 400,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
