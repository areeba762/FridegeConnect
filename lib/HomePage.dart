import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginView.dart';
import 'SplashScreen.dart';
import 'Home_tab.dart';
import 'admob/admob_manager.dart';
import 'fridge_items.dart';
import 'fridge_items_tab.dart';
import 'profile_tab.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;





  // Function to change the selected tab in the bottom navigation bar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (_currentIndex) {
      case 0:
        currentPage = Home_tab();
        break;
      case 1:
        currentPage = profile_tab();
        break;
      case 2:
        currentPage = add_fridge_items();
        break;
      default:
        currentPage = Home_tab();
    }

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Fridge Connect'),
          actions: [
            IconButton(
              onPressed: () => _handleLogout(context),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: currentPage,

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.kitchen),
              label: 'Fridge Items',
            ),
          ],
        ),
      ),
    );
  }



  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _logout(context);
                },
                child: Text("Logout",
                 style: TextStyle(color: Colors.white),),
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple), // Change the color here
                   ),
                ),
            ],
          ),
    );
  }


  Future<void> _logout(BuildContext context) async {
    try {
      // TODO: Add any other necessary logout logic here, like signing out from Firebase.
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();


      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', false);


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SplashScreen()),
            (route) => false,
      );

      Fluttertoast.showToast(msg: 'Logout successful');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred during logout: $e');
    }
  }

}